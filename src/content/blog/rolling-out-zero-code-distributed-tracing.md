---
title: "Rolling out distributed tracing without breaking what already worked"
date: 2026-08-10
excerpt: "Onboarding a Java microservices platform onto distributed tracing without asking any team to touch their code, and without disturbing the logging and metrics pipelines already running in production."
tags: ["observability", "opentelemetry", "kubernetes", "tracing"]
---

Most teams don't lack telemetry -- they lack traces. Logs and metrics are usually mature by the
time a platform reaches any real scale, but distributed tracing tends to arrive later, after the
system has already grown enough microservices that a single slow request can cross a dozen
services and nobody can say which hop actually caused it. That was the starting point here: a
Java microservices platform on Kubernetes with solid logging and metrics already in production,
and no tracing at all.

## The constraint that shaped everything

The obvious way to add tracing is to have each team instrument their own service -- add the
OpenTelemetry SDK, wrap the right calls, ship a new build. In practice that doesn't scale past a
handful of teams: it turns a platform-level rollout into dozens of individual engineering
projects, each competing with that team's actual roadmap. So the requirement going in was
zero-code: tracing had to attach to a service without its owners changing a single line.

The second requirement was just as important: don't touch what's already working. The platform's
logging and metrics pipelines were mature and depended on daily. Whatever got built for tracing
had to be additive -- coexist cleanly alongside the existing pipelines, not replace or compete with
them -- so teams could adopt tracing on its own timeline without any risk to signals they already
relied on.

## Zero-code instrumentation via Kubernetes

The answer to the first constraint was Kubernetes-native auto-instrumentation: an OpenTelemetry
operator running in-cluster that watches for a pod annotation and, when present, injects the Java
instrumentation agent into the pod automatically via `JAVA_TOOL_OPTIONS` -- no rebuild, no code
change, no dependency added to the service itself. Onboarding a service came down to two
annotations and a label. That's a very different adoption curve than "add tracing to your
service" -- it's closer to "opt into a platform capability."

## A fan-in collector architecture

Spans from an instrumented pod don't go straight to the tracing backend. They flow through a
small collector hierarchy: a lightweight collector alongside each workload receives spans locally,
forwards them to a per-namespace or per-cluster gateway collector, which batches and forwards to
the central ingestion pipeline in front of the tracing backend (Grafana Tempo, queried with
TraceQL). That fan-in shape matters for two reasons: it keeps each hop cheap and horizontally
scalable instead of every pod talking directly to a shared backend, and it gives you one place per
cluster to apply sampling, batching, or backpressure policy without touching application code.

## Coexisting with what's already there

To satisfy the second constraint, the traces path was deployed and rolled out independently of
metrics and logs, with each signal in the new observability layer explicitly toggled off except
tracing. That kept the blast radius of the rollout limited to exactly the new capability being
introduced, let each team adopt tracing without any risk to the logging or metrics they already
depended on, and meant a rollback, if ever needed, only had to undo one signal instead of an
entire observability stack.

## What broke, and what it taught the runbook

None of this worked cleanly on the first pass, and the failures were the more instructive part.

**Sampling is a silent trap.** The default sampler only records a trace if the incoming request
already carries a trace context header -- which means a team can wire everything up correctly,
call their own service directly to test it, and see zero traces, because there was nothing
upstream to originate that header. That single gotcha accounted for more early "tracing isn't
working" reports than any actual bug, and it's now the first thing the runbook calls out.

**Cross-cloud image pulls fail silently at the platform layer.** As services span clusters across
different cloud providers, one background job needed for the observability stack was still
pointing at a registry hosted on a different cloud than the cluster it ran in -- a mismatch that
had nothing to do with tracing directly, but blocked the secrets that downstream tracing
components depended on. Debugging it meant tracing a chain of failures backward from "collector
pods can't start" to a single unpinned image reference three layers removed.

**CI/CD promotion can go quiet without erroring.** In one rollout, a code change merged cleanly
but the resulting container image never got built, because the webhook that should have notified
the build pipeline of the merge was never registered on the repository in the first place --
there was no error, just nothing happening. The fix was trivial once found; finding it meant
walking the full path from "merge happened" to "image should exist" and checking each link.

## Turning it into a pattern, not a one-off

None of the above matters much as a single success story -- the actual deliverable was a reference
implementation plus an onboarding runbook that captured all of it: the two annotations and label
needed for zero-code instrumentation, the coexistence strategy for rolling out traces without
touching existing pipelines, and a troubleshooting section built directly from the sampling,
registry, and CI/CD issues above. That runbook is what let other teams onboard their own services
without re-discovering the same failures, and it's since become the standard integration pattern
used across the platform.
