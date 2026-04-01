# Task: Stripe Cancel Sync

## ID
TASK-0003

## State
ready

## Branch
`feature/stripe-cancel-sync`

## Roadmap Reference
- `ops/TODO.md` -> `Immediate Follow-Up (Stripe Cancel Sync)`

## Goal
When a Stripe subscription is canceled outside ExposeGPU, sync that cancellation back into ExposeGPU so the project no longer appears billing-enabled and new deployments/resumes are blocked by the existing billing gate.

## Blast Radius
small

## Rollout Class
staging

## Context
Today Stripe checkout/webhook flow enables billing locally, but Stripe-side cancellation does not clear local billing state. That leaves projects in an invalid state where Stripe considers the subscription canceled while ExposeGPU still treats billing as enabled.

The existing local disable route already clears project billing state and billing-item mappings. The missing piece is to react to Stripe webhook cancellation events and apply equivalent cleanup locally.

## Scope
- Handle Stripe `customer.subscription.deleted` in the webhook.
- Match the project by `stripe_subscription_id` only.
- Enforce unique local `projects.stripe_subscription_id` mappings at the model/database layer.
- Clear the full local billing state for the matching project:
  - `stripe_subscription_id = NULL`
  - `stripe_subscription_item_id = NULL`
  - `billing_enabled_at = NULL`
  - delete `project_billing_items` rows for the project
- Extract shared local cleanup logic so manual disable and webhook cancellation use the same state-clearing path.
- Add focused webhook and gating regression tests.

## Out of Scope
- `customer.subscription.updated` handling.
- `cancel_at_period_end` or grace-period semantics.
- New schema fields for cancellation status.
- Webapp/UI changes for in-app cancellation.
- Broader billing UX redesign.

## Future Follow-Ups
- Add explicit in-app cancellation UX so users can cancel from ExposeGPU directly, not only through Stripe surfaces.
- Decide how `customer.subscription.updated` with `cancel_at_period_end` should be represented in local state.
- Consider a separate local status for "cancellation scheduled" if period-end cancellation becomes important.

## Dependencies / Prerequisites
- Existing Stripe webhook flow remains the entry point for billing state sync.
- Existing webhook signature verification remains in place before any cancellation handler runs.
- Existing billing disable cleanup path is the source of truth for how local billing state should be cleared.

## Constraints
- Keep the slice to Stripe-side cancellation sync only.
- Do not redesign billing state modeling beyond enforcing one local project per Stripe subscription id.
- Prefer idempotent webhook handling.
- If the canceled Stripe subscription does not match any project by `stripe_subscription_id`, log a warning and return 200 with no local state change.

## Risks
- Matching the canceled Stripe subscription back to the correct project must be reliable, so the handler should use `stripe_subscription_id` only.
- If the migration adds uniqueness while duplicate local subscription ids already exist, the migration will fail and require manual cleanup.
- Local cleanup may drift if webhook cancellation and manual disable use different code paths.
- If tests cover only webhook state changes and not the billing gate effect, the user-visible bug may regress later.
- If webhook signature verification regresses, a forged cancellation event could clear billing state incorrectly.

## Artifacts to Update
- likely `api/app/routers/webhooks.py`
- likely `api/app/routers/billing.py`
- likely `api/app/models.py`
- likely `db/migrations/`
- tests under `tests/billing/` and/or `tests/api/`
- task-local handoff files under `agentic/handoffs/TASK-0003-stripe-cancel-sync/`

## Verification Plan
- Add a webhook test for `customer.subscription.deleted` that clears:
  - `stripe_subscription_id`
  - `stripe_subscription_item_id`
  - `billing_enabled_at`
  - `project_billing_items`
- Add an idempotency/no-op test for repeated cancellation delivery.
- Add a no-op test for a canceled subscription ID that matches no project.
- Add a migration/model test showing duplicate `stripe_subscription_id` values are rejected after the schema change.
- Add or update a regression test showing the project is blocked by the existing billing gate after sync.
- Confirm webhook signature verification still protects the cancellation handler path.
- Record what was validated by tests versus what was not exercised end-to-end.

## Done When
- Stripe `customer.subscription.deleted` matches the project by `stripe_subscription_id`.
- Shared cleanup logic is used by both manual disable and webhook cancellation.
- Local schema/model enforce at most one project per `stripe_subscription_id`.
- Webhook cancellation clears:
  - `stripe_subscription_id`
  - `stripe_subscription_item_id`
  - `billing_enabled_at`
  - associated `project_billing_items`
- Repeated delivery is safe and idempotent.
- Regression tests cover both local cleanup and the resulting billing gate behavior.
