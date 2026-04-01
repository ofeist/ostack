# Task: <title>

## ID
TASK-XXXX

## Status
`draft` | `ready` | `in_progress` | `review` | `qa` | `blocked` | `done`

## Branch
`feature/<task-slug>`

## Roadmap reference
Optional:
- iteration / thin-slice reference
- TODO section
- issue / PR link

## Goal
What should be achieved?

## Context
Why are we doing this?
What already exists?

## Scope
What is included in this slice?

## Out of scope
What must not be touched in this slice?

## Dependencies / prerequisites
What must already exist or be merged first?
Examples:
- env vars available
- earlier slice merged
- staging setup complete

## Constraints
Examples:
- minimal diff
- no schema refactor
- preserve API response shape

## Blast radius
How wide is the likely impact?
Examples:
- small: isolated file or endpoint
- medium: multiple layers but one bounded feature
- large: deploy, billing, migration, or cross-cutting behavior

## Rollout class
`local` | `ci-local` | `staging` | `prod-sensitive`

## Risks
Known risks or design concerns.

## Artifacts to update
Which code, docs, generated files, env templates, workflows, or runbooks are expected to change?

## Verification plan
Which tests / commands / deploy checks should be run?

## Slice readiness check
A task should usually be `ready` only if:
- the goal is clear
- the branch naming is clear
- dependencies are known
- the rollout class is chosen
- the verification plan is concrete

## Rollout notes
Only if relevant.

## Open questions
Only if relevant.

## Done when
Concrete acceptance criteria.
