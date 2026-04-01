# Handoff: Stripe Cancel Sync

## Role
Builder

## Branch
`feature/stripe-cancel-sync`

## Context
Thin slice for `TASK-0003`: sync Stripe-side subscription cancellation back into ExposeGPU via the webhook so canceled subscriptions no longer leave projects locally billing-enabled.

## Scope Checked
- Stripe webhook routing and event handling in `api/app/routers/webhooks.py`
- Shared local billing cleanup used by both webhook cancellation and manual disable
- Local uniqueness enforcement for `projects.stripe_subscription_id`
- Focused webhook and billing-disable regression coverage

## Done
- Added shared cleanup helper in `api/app/billing/state.py`.
- Switched manual disable in `api/app/routers/billing.py` to the shared helper.
- Added `customer.subscription.deleted` handling in `api/app/routers/webhooks.py`.
- Webhook cancellation now matches by `stripe_subscription_id` only.
- Webhook cancellation now fails closed if multiple local projects share the same `stripe_subscription_id`.
- Enforced unique local `projects.stripe_subscription_id` mappings in `api/app/models.py` and `db/migrations/033_unique_project_stripe_subscription_id.sql`.
- Webhook cancellation clears:
  - `stripe_subscription_id`
  - `stripe_subscription_item_id`
  - `billing_enabled_at`
  - `project_billing_items`
- Added focused tests in `tests/billing/test_stripe_webhook.py` for:
  - cancellation cleanup
  - no-op when subscription is not mapped
  - no-op when subscription mapping is ambiguous
  - deployment gate blocks again after sync
- Added migration coverage in `tests/db/test_bootstrap_schema.py` showing duplicate `stripe_subscription_id` values are rejected after migration 033.

## Not Done
- No `customer.subscription.updated` handling.
- No `cancel_at_period_end` semantics.
- No webapp/UI cancellation improvements.
- No full end-to-end Stripe/live staging test.

## Artifacts Changed
- `api/app/billing/state.py`
- `api/app/routers/billing.py`
- `api/app/routers/webhooks.py`
- `api/app/models.py`
- `db/migrations/033_unique_project_stripe_subscription_id.sql`
- `tests/billing/test_stripe_webhook.py`
- `tests/db/test_bootstrap_schema.py`
- `agentic/handoffs/TASK-0003-stripe-cancel-sync/builder.md`

## Risks
- Subscription matching is intentionally strict (`stripe_subscription_id` only), so orphaned or already-cleaned Stripe events become no-op responses.
- Ambiguous local subscription mappings now return a no-op response instead of clearing an arbitrary project.
- Migration 033 will fail closed if any environment already contains duplicate non-NULL `stripe_subscription_id` values.
- `customer.subscription.updated` is still unsupported, so period-end cancellation semantics remain a future follow-up.

## Verification
- `python3 -m py_compile api/app/billing/state.py api/app/routers/billing.py api/app/routers/webhooks.py tests/billing/test_stripe_webhook.py`
- `ENVIRONMENT=dev docker compose -p deploy --env-file deploy/envs/.env.dev -f deploy/docker-compose.yaml -f deploy/docker-compose.dev.yaml run --no-deps --rm -e PYTHONPATH=/app api pytest -q tests/billing/test_stripe_webhook.py -k "subscription_deleted or webhook_enables_billing or webhook_idempotency"`
  - result: `6 passed, 13 deselected`
- `ENVIRONMENT=dev docker compose -p deploy --env-file deploy/envs/.env.dev -f deploy/docker-compose.yaml -f deploy/docker-compose.dev.yaml build api && ENVIRONMENT=dev docker compose -p deploy --env-file deploy/envs/.env.dev -f deploy/docker-compose.yaml -f deploy/docker-compose.dev.yaml run --no-deps --rm -e PYTHONPATH=/app api pytest -q tests/billing/test_enable_disable.py -k "disable_billing"`
  - result: `2 passed, 5 deselected`
- `python3 -m py_compile api/app/models.py tests/db/test_bootstrap_schema.py`
- `ENVIRONMENT=dev docker compose -p deploy --env-file deploy/envs/.env.dev -f deploy/docker-compose.yaml -f deploy/docker-compose.dev.yaml build api && ENVIRONMENT=dev docker compose -p deploy --env-file deploy/envs/.env.dev -f deploy/docker-compose.yaml -f deploy/docker-compose.dev.yaml run --no-deps --rm -e PYTHONPATH=/app -e SQLITE_PATH=<fresh-temp-db> api pytest -q tests/db/test_bootstrap_schema.py::test_migration_033_enforces_unique_project_subscription_ids tests/billing/test_stripe_webhook.py -k "subscription_deleted"`
  - result: `4 passed, 17 deselected`

## Operational Notes
The normal `docker compose up -d api` path is currently blocked in this environment by an unrelated `migrator` failure, so focused verification was run with `docker compose run --no-deps ...` against the freshly built API image instead.

## Next
- Reviewer: check that the schema-level uniqueness change stays narrow and does not conflict with the webhook runtime guard.
- QA: validate the focused test evidence, especially migration 033, and confirm the slice is ready without broader Stripe-state changes.
