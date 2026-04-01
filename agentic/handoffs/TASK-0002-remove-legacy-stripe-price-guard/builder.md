# Handoff: Remove Legacy Stripe Price Guard

## Role
Builder

## Branch
`feature/remove-legacy-stripe-price-guard`

## Context
Thin slice for `TASK-0002`: remove the legacy `STRIPE_PRICE_GPU_MINUTE` deploy guard without taking on runtime fallback cleanup or a broader Stripe env cleanup.

## Scope Checked
- Production deploy workflow guard logic in `.github/workflows/prod-deploy.yml`
- Staging/prod workflow references were inspected to confirm where the legacy var is still present

## Done
- Replaced the production fail-fast guard requirement for `STRIPE_PRICE_GPU_MINUTE` with the three per-GPU Stripe price vars.
- Updated the nearby production guard comment so it matches the current billing model.

## Not Done
- Legacy env injection of `STRIPE_PRICE_GPU_MINUTE` remains in `prod-deploy.yml` and `staging-deploy.yml`.
- No runtime fallback or broader docs/code reference cleanup was attempted.
- No end-to-end staging/prod deploy was run.

## Artifacts Changed
- `.github/workflows/prod-deploy.yml`
- `agentic/handoffs/TASK-0002-remove-legacy-stripe-price-guard/builder.md`

## Risks
- A later deploy step could still depend on the legacy variable indirectly even though the fail-fast guard no longer requires it.
- Staging still carries the legacy injection path, so this slice does not remove all workflow references yet.

## Verification
- Inspected all workflow references to `STRIPE_PRICE_GPU_MINUTE` under `.github/workflows/`.
- Confirmed only `prod-deploy.yml` had a real required-variable guard on the legacy var.
- YAML parse check passed for:
  - `.github/workflows/prod-deploy.yml`
  - `.github/workflows/staging-deploy.yml`
- No deploy workflow was executed.

## Operational Notes
This slice intentionally updates only the deploy guard. It does not remove the legacy env placeholder or sed injection path because those belong to later cleanup slices.

## Next
- Reviewer: check that the slice stayed narrow and that the required production Stripe vars now match the per-GPU billing model.
- QA: validate that the workflow files still parse and that no other deploy guard still enforces the legacy variable.
