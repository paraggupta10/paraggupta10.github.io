---
title: "Cloud cost optimization: three initiatives that actually moved the needle"
date: 2026-06-15
excerpt: "Reserved-capacity planning for DynamoDB, traffic-aware rightsizing for Aerospike, and a unified multi-cloud cost dashboard -- three different approaches to the same underlying problem: spend that had drifted away from actual usage."
tags: ["cost-optimization", "aws", "dynamodb", "aerospike", "finops"]
---

Cloud cost work tends to get lumped together as one activity, but in practice
it splits into a few genuinely different problems: committing to capacity
correctly, sizing infrastructure to the traffic it actually serves, and
simply being able to see what you're spending in the first place. Three
initiatives from the last year or so, each tackling one of those.

## Reserved capacity planning for DynamoDB

DynamoDB usage was the single largest moving cost driver on the project. The
obvious lever -- reserving capacity instead of paying on-demand -- isn't a
decision you can make casually, because RCU/WCU reservations apply at the
account level, not per table. That means the math has to hold in aggregate,
across every table's read/write pattern, before you commit to a term that
long.

Rather than reserving capacity outright, I partnered with management to
model growth plans first, then ran a detailed, automated analysis of
read/write patterns across 100+ tables to see what an account-level
reservation would actually look like once every table's usage was summed
and projected forward. The analysis also flagged which tables didn't belong
in that reservation at all -- workloads spiky or unpredictable enough that
On-Demand billing was the better fit -- and those were carved out before
committing, which minimized both cost and the risk of over-committing to a
number that wouldn't hold.

Net result: a ~74% reduction versus on-demand pricing, roughly $280K in
annual savings, from getting the aggregate model right before signing a
3-year term rather than after.

## Traffic-aware rightsizing for Aerospike

Aerospike was a different kind of problem. Every service ran dedicated
clusters, and those clusters were replicated uniformly across 12+ regions
regardless of how much traffic each region actually served. That's an easy
default to end up with -- uniform replication is simple to reason about --
but it means you're paying full freight in regions serving a fraction of the
load.

I led a shift to traffic-aware infrastructure sizing: benchmarking each
service's actual workload, working directly with Aerospike's support team
to identify the right hardware profile per use case (including how NVMe
capacity was allocated), and consolidating services with compatible needs
onto shared clusters via separate namespaces instead of giving everything
fully isolated infrastructure.

The harder part wasn't the technical work, it was organizational: getting
teams comfortable that a smaller, right-sized footprint wouldn't hurt their
performance. The only thing that actually moved that conversation was
sharing complete end-to-end benchmark and load-test results before any
change shipped -- not summaries, the full data. The program is still
rolling out org-wide, but for one major consuming team alone it has already
delivered roughly $40K in annual savings.

## Seeing real spend across a fragmented stack

The third problem was more basic: with services spread across multiple
regions and two clouds (AWS and Azure), plus third-party platforms like
MongoDB Atlas, Redis, and Splunk, nobody had an accurate picture of what any
of it actually cost. Part of that was fragmentation -- the data lived in
different places -- and part of it was that raw on-demand list pricing
doesn't reflect an org's actual negotiated rates, so even the numbers people
did have were wrong in a consistent direction.

I built a consolidated, AI-assisted dashboard that pulled spend data from
all of those sources into one place, normalized to true effective cost
rather than list price. That sounds like a reporting project, but the real
value was what it made possible afterward: a concrete basis for deciding
what to downscale, decommission, or upscale to match actual SLA/SLO needs
instead of whatever was originally (and statically) provisioned. That
visibility work opened up a pipeline of further savings that's still
growing.

## The common thread

None of these were about cutting for its own sake. Each one started with
actually modeling or measuring usage -- aggregate RCU/WCU demand, per-region
traffic, true effective spend -- before changing anything, and each one
needed a way to bring the rest of the org along (growth-plan buy-in for the
DynamoDB commitment, load-test evidence for the Aerospike rightsizing,
visibility for the dashboard to even be actionable). The infrastructure
change was usually the easy part; getting the measurement right, and getting
people comfortable acting on it, was where the actual work was.
