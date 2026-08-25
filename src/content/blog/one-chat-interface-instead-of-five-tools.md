---
title: "One chat interface instead of five tools: building Lens"
date: 2026-04-22
excerpt: "Investigating an issue across metrics, logs, and a database usually means several open tools and a manual correlation step. Lens replaces that with one natural-language chat interface — here's the architecture behind it."
tags: ["ai", "multi-agent", "observability", "python"]
---

Investigating a problem across a service with more than a couple of
telemetry systems always plays out the same way: open the metrics
dashboard, open the log search tool, open the database console, maybe
an infra/APM tool too, and manually stitch together what each one is
telling you. None of that is hard individually. What's hard is holding
all of it in your head at once, under time pressure, while a system is
degraded.

Lens is a natural-language investigation assistant built to replace
that manual correlation step with a single chat interface. Ask a
question in plain English, and a coordinator figures out which
specialist agent — logs, metrics, a document store, database
performance, or infrastructure — should look into it, lets agents
autonomously pull in a peer for corroborating evidence when needed, and
returns a synthesized answer alongside a full trace of what was checked
and why.

## The problem: several tools, one mental correlation step

The pain isn't any single tool being bad. It's that a real
investigation almost never lives in one system. "Why did this job take
three times longer than normal?" might need a metrics dashboard to
confirm a latency spike, a log search to find the actual error, and a
database performance view to check whether a slow query was the root
cause underneath both of those symptoms. Doing that by hand means
knowing which tools to open, which query language each one speaks, and
being disciplined enough to actually cross-reference timestamps between
them instead of guessing.

## The fix: one interface, automatic routing, agents that call each other

Lens's coordinator takes the raw question, classifies it — which domain
does this touch, and does it need a quick lookup or a deeper multi-step
investigation — and routes it to the specialist agent that owns that
domain. That agent doesn't have to work in isolation: if a metrics
agent finds an anomaly and needs corroborating log evidence, it can
autonomously call the logs agent for it, the same way a person would
say "let me go check the logs for that" mid-investigation.

The result is one conversational entry point where the correlation work
— the part that used to be entirely manual — happens automatically, and
the coordinator's routing decision, each agent's findings, and any
cross-agent hand-off are all shown back to the user as a transparent
trace rather than hidden behind a single opaque answer.

## An architecture, not a single model call

The interesting engineering problem here isn't "call an LLM" — it's the
multi-agent shape around it: a coordinator, a set of specialist agents
with clearly scoped responsibilities, and a protocol for one agent to
consult another for corroborating evidence. Lens is built directly on
Google's Agent Development Kit (ADK): the coordinator and every
specialist are real ADK agents, coordinator routing uses ADK's native
sub-agent transfer mechanism, and cross-agent consultation uses ADK's
`AgentTool` to let one specialist call another. The model layer runs
through ADK's LiteLLM integration, so which LLM every agent uses is a
single config value — swapping from OpenAI to Claude Sonnet or a Gemini
model needs no code changes.

## The trade-off: no offline fallback anymore

An earlier version of this project had a hard requirement that every
layer — routing, each agent's investigation, and cross-agent
collaboration — work with zero AI calls, via a deterministic rule-based
path underneath each one. Rebuilding on ADK's real agent runtime meant
giving that up: routing, tool selection, and the final answer are all
genuine model calls now, so a working LLM API key is required for Lens
to do anything at all. That's a real loss along one dimension — it can
no longer demo with no API key configured — traded for a smaller, more
honest codebase that runs on a real agent framework instead of
reimplementing a piece of what one already does well.
