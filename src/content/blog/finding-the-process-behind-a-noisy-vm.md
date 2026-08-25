---
title: "Finding the process behind a noisy VM: AI-based root cause analysis across a fleet"
date: 2026-02-10
excerpt: "Cortex VM Analyzer compares a suspect host's VM- and process-level metrics against a healthy peer, and uses AI-based analysis to name the specific process behind a resource bottleneck or memory leak -- before anyone opens application logs."
tags: ["observability", "ai", "python", "streamlit"]
---

Anyone who's run a fleet of servers doing the same job -- hundreds of
machines behind the same piece of infrastructure -- has seen this
pattern: every so often, a handful of hosts start behaving abruptly.
Higher error rates, worse latency, no obvious single cause. And in my
experience, when you actually chase those incidents down, the root
cause keeps landing in the same place: a resource bottleneck, a memory
leak in one specific process, or some other infra-level issue -- not
something you'd ever find by immediately diving into application logs.

Cortex VM Analyzer is built around that exact workflow: comparing a
suspect host's metrics against a healthy peer running the identical
workload, at both the VM level and the process level, and using
AI-based analysis to say which specific process is responsible before
anyone starts application-level debugging.

## Comparing more than just the VM

Most "compare two hosts" tooling stops at VM-level aggregates -- overall
CPU, overall memory. That's useful for confirming *that* something is
different, but it doesn't tell you *why*. Two hosts running the same
four background processes can have identical VM-level memory usage
while one of those four processes is quietly leaking and another is
quietly shrinking to compensate.

So every host here runs the same fictional set of processes,
and every analysis tracks each process's CPU, resident memory, and file
descriptor count alongside the VM-level metrics. Comparing "the same
process" across a healthy and an unhealthy host is what actually
isolates the problem -- which is why the Compare VMs view sorts
directly by the biggest spread per process/metric across the hosts
being compared. The process with the largest spread is, almost by
construction, the most useful lead.

## Detecting a leak without knowing a process's baseline

A static memory threshold doesn't work well at the process level,
because a legitimate cache process might sit at 600MB all day while a
legitimately small one might be leaking from 150MB. The sharper signal
is growth: does this process's memory climb over the analysis window,
regardless of where it started? That's a much more direct match for
what a memory leak actually looks like, and it's the check that catches
the leak scenarios here well before a static threshold would.

## AI-based analysis over both layers at once

The rule engine's job is to surface candidates -- threshold breaches,
spikes, RSS growth -- at both the VM and process level. The AI layer's
job is to reason across both of those layers together and commit to a
specific diagnosis: is this a bottleneck, a leak, or something else at
the infra level, and if the process-level data supports it, which
process explains it. That's a meaningfully different (and harder) task
than narrating a single VM's metrics in isolation, because it has to
weigh a VM-level statistic against a much more specific process-level
one and decide which is the more useful thing to tell an on-call
engineer.

The rule-based path underneath it does the same reasoning
deterministically, so the app never produces a blank or broken answer
if AI isn't available -- but that's a reliability property of the
implementation, not the point of the project. The point is the
AI-based, cross-layer diagnosis in front of it.

## Why this shape held up

Building the VM-level and process-level pipelines in parallel from the
start -- rather than bolting process metrics on afterward -- meant the
comparison logic, the rule engine, and the AI prompt could all be
designed around the same core question from day one: not "is this VM
healthy," but "is this VM different from its healthy peers, and if so,
where specifically." That question is what actually shortens an
investigation, and it's the same question a resource-bottleneck or
memory-leak investigation should start with in any real fleet, before
anyone touches an application log.
