---
title: "Filling a gap in the Terraform MongoDB Atlas provider"
date: 2026-03-18
excerpt: "Why I published terraform-mongodbatlas-indexes: declarative, YAML-driven MongoDB Atlas index management, backed by unit tests, a live-database integration test, and CI on every push."
tags: ["terraform", "mongodb", "infrastructure-as-code", "ci"]
---

The official Terraform provider for MongoDB Atlas covers clusters, users,
network peering, and most of what you'd expect from a cloud database
provider — but it doesn't give you a clean, declarative way to manage
collection indexes. You either drop into imperative scripts, manage indexes
by hand, or wire up something bespoke per project. I ran into this gap
enough times that I decided to publish a module to close it:
`terraform-mongodbatlas-indexes`.

## What the module actually does

The idea is simple: describe the indexes you want per collection in a YAML
file, and let the module reconcile Atlas to match that description. Instead
of writing Terraform resource blocks by hand for every index on every
collection — which gets repetitive and error-prone fast — you get one
source of truth for index state that's easy to read, easy to diff in a pull
request, and easy to keep in version control alongside the rest of your
infrastructure code.

## Why declarative, YAML-driven index management matters

Indexes are infrastructure, but they're often treated as an afterthought —
added ad hoc by whoever notices a slow query, then forgotten. That leads to
drift: nobody is quite sure which indexes exist in which environment, or
why. Declaring them in YAML and running them through Terraform gives you
the same guarantees you already expect for the rest of your infra: a
plan step that shows you exactly what will change before it changes,
a diff-able history of every index that's been added or removed, and one
place to look instead of spelunking through a database console across
multiple environments.

## Testing an infrastructure module properly

Publishing something to the public Terraform Registry raises the bar on
testing, because other people will depend on it without reading the
implementation first. I didn't want to ship something that only worked on
my machine, so the module has three layers of verification:

- **Unit tests** that exercise the YAML-parsing and diffing logic directly,
  without touching a real database, so the core logic is fast to verify.
- **A live-database integration test** that actually applies the module
  against a real MongoDB instance and confirms the indexes it claims to
  create actually exist with the right keys and options. Unit tests alone
  can't catch a subtle mismatch between what the code intends and what
  Atlas actually does with it — you need to hit the real thing at least
  once.
- **CI on every push**, so neither of the above is optional or something I
  have to remember to run locally before merging.

That combination — fast unit coverage plus a real integration check, both
gated in CI — is the same shape of testing pyramid I'd want for any
infrastructure code, not just a side project. The only difference here is
that this one runs in the open, on the Terraform Registry, so it has to
hold up under someone else's use case, not just mine.
