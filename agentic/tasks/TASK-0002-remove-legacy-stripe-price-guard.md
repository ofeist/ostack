# Task: Remove Legacy Stripe Price Guard

## ID
TASK-0002

## State
ready

## Branch
`feature/remove-legacy-stripe-price-guard`

## Roadmap Reference
- `ops/TODO.md` -> `Near-Term Follow-Up (Remove Legacy STRIPE_PRICE_GPU_MINUTE)`

## Goal
Remove the legacy `STRIPE_PRICE_GPU_MINUTE` requirement from deploy workflow guards so staging and production checks match the real per-GPU billing configuration.

## Blast Radius
small

## Rollout Class
staging

## Context
The billing system now uses per-GPU Stripe price variables:
- `STRIPE_PRICE_GPU_MINUTE_L4_1_24G`
- `STRIPE_PRICE_GPU_MINUTE_L40S_1_48G`
- `STRIPE_PRICE_GPU_MINUTE_H100_1_80G`

The legacy single-price variable still exists in some deploy workflow guard logic as compatibility baggage. That makes deploy checks misleading because they still require a variable that is no longer the real billing model.

## Scope
- Update deploy workflow guard logic so `STRIPE_PRICE_GPU_MINUTE` is no longer a required variable.
- Ensure required-variable checks align with the current per-GPU Stripe price model.
- Update nearby comments or operator-facing wording if it still says the legacy variable is required.

## Out of Scope
- Removing any runtime fallback that still reads `STRIPE_PRICE_GPU_MINUTE`.
- Removing all remaining docs/code references to the legacy variable.
- Changing Stripe billing behavior.
- Broader deploy workflow refactors.

## Dependencies / Prerequisites
- Current billing architecture remains the per-GPU Stripe pricing model.
- Existing deploy workflows already know about the per-GPU price variables.

## Constraints
- Keep the slice narrow: deploy workflow guards only.
- Do not mix runtime cleanup or broad billing config cleanup into this task.
- Preserve current deploy behavior apart from the required-variable set.

## Risks
- A workflow may still depend on the legacy variable indirectly, so removing the guard could expose another stale dependency.
- A staging/prod workflow may enforce an incomplete per-GPU variable set if we patch only one file.
- Operator-facing docs/comments may drift if the guards are changed without updating nearby wording.

## Artifacts to Update
- likely `.github/workflows/prod-deploy.yml`
- maybe `.github/workflows/staging-deploy.yml`
- task-local handoff files under `agentic/handoffs/TASK-0002-remove-legacy-stripe-price-guard/`

## Verification Plan
- Inspect all deploy workflow required-variable checks for `STRIPE_PRICE_GPU_MINUTE`.
- Verify the updated workflow files parse correctly.
- Confirm the required-variable set matches the per-GPU price vars and no longer lists the legacy single-price var.
- Record what was validated by inspection versus what was not exercised end-to-end.

## Open Questions
- Does any deploy workflow other than `prod-deploy.yml` still enforce the legacy variable?

## Done When
- No deploy workflow guard still requires `STRIPE_PRICE_GPU_MINUTE`.
- Required deploy-time Stripe price variables are the per-GPU vars only.
- Any nearby comments/messages no longer claim the legacy variable is required.
- Builder handoff records what was checked and what was not run.
