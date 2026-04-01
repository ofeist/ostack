# Task: Add Cut Release Workflow

## ID
TASK-0001

## Status
`ready`

## Branch
`feature/cut-release-workflow`

## Roadmap reference
- `ops/TODO.md` — Release Tag Automation
- `ops/versioning-policy.md`

## Goal
Add a manual GitHub Actions workflow that computes the next plain semver release tag from a chosen bump type (`patch`, `minor`, or `major`), creates an annotated tag on the current `main` HEAD, and pushes it so the existing release image workflow can run.

## Context
The repo already has:
- `.github/workflows/release.yml` to build and publish release images when a `v*` tag exists
- `.github/workflows/prod-deploy.yml` to deploy a chosen release tag
- `ops/versioning-policy.md` defining plain semver and bump rules

What is missing is the step that cuts the next release tag automatically. Right now that part is still manual.

## Scope
Included in this slice:
- add `.github/workflows/cut-release.yml`
- support manual dispatch with a required bump type input: `patch`, `minor`, or `major`
- resolve the latest stable `vX.Y.Z` tag when it exists
- otherwise, if historical prerelease tags exist, promote the highest prerelease base to stable
- otherwise, bootstrap to `v0.1.0`
- compute the next semver tag according to `ops/versioning-policy.md`
- create and push an annotated tag
- dispatch `release.yml` explicitly via `workflow_dispatch` on the pushed tag ref
- emit a useful workflow summary
- add or update minimal docs/comments if needed for operator clarity

## Out of scope
- changing the existing image build logic in `.github/workflows/release.yml`
- changing production deploy behavior in `.github/workflows/prod-deploy.yml`
- adopting release-please, GitVersion, or conventional commits
- changelog generation
- auto-inferring bump type from commits or PR labels

## Dependencies / prerequisites
- `ops/versioning-policy.md` is merged on `main`
- existing release workflow remains tag-driven
- workflow has permission to create and push tags

## Constraints
- keep the diff small and workflow-focused
- preserve compatibility with existing `v*` release flow
- do not redesign the broader release system in this slice
- do not introduce prerelease suffixes or RC logic

## Blast radius
`low`

## Rollout class
`staging`

## Risks
- tag creation with `GITHUB_TOKEN` will not reliably trigger downstream tag-based workflows, so this slice must dispatch `release.yml` explicitly after pushing the tag
- incorrect stable/prerelease bootstrap parsing could compute the wrong next version
- accidental support for prerelease tags could reintroduce old complexity
- the operational blast radius starts when someone actually runs the workflow and publishes a tag that triggers release image publication

## Artifacts to update
- `.github/workflows/cut-release.yml`
- optional: small note in release workflow docs if operator behavior should be made explicit
- optional: `ops/TODO.md` if the task should be marked more explicitly after merge
- optional: small docs note if operator usage needs to be recorded

## Verification plan
- validate workflow YAML structure
- review the semver parsing logic carefully against current tags
- confirm the workflow prefers the latest stable `vX.Y.Z` tag when one exists
- confirm historical prerelease bootstrap behavior when no stable semver tag exists but prerelease tags do:
  - latest prerelease base `v0.1.5-rc14` -> `v0.1.5`
- confirm true bootstrap behavior when no semver-like tags exist:
  - start at `v0.1.0`
- confirm the computed next version for sample cases:
  - latest `v0.1.5` + `patch` -> `v0.1.6`
  - latest `v0.1.5` + `minor` -> `v0.2.0`
  - latest `v0.1.5` + `major` -> `v1.0.0`
- confirm the workflow summary states the created tag and explicit tag-ref release dispatch clearly
- if practical, run a dry review against GitHub Actions syntax and permission expectations

## Slice readiness check
A task should usually be `ready` only if:
- the goal is clear
- the branch naming is clear
- dependencies are known
- the rollout class is chosen
- the verification plan is concrete

This task is `ready`.

## Rollout notes
This slice should be merged before any attempt to use the new release-cut workflow. Existing manual tag creation remains the fallback until the workflow is verified.

## Done when
- `.github/workflows/cut-release.yml` exists
- the workflow accepts `patch|minor|major`
- it computes the next stable semver tag from the latest stable `vX.Y.Z` when one exists
- if no stable semver tag exists but historical prerelease tags do, it promotes the highest prerelease base to stable
- if no semver-like tags exist, it bootstraps to `v0.1.0`
- it creates and pushes an annotated tag
- it explicitly dispatches `release.yml` on the pushed tag ref
- it does not rely on RC/prerelease logic
- the implementation is documented enough for a human operator to use it without guesswork
