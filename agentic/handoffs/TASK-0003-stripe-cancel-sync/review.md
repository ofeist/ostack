# Handoff: Stripe Cancel Sync

## Role
Reviewer

## Branch
`feature/stripe-cancel-sync`

## Findings
- Accepted finding: `customer.subscription.deleted` must fail closed if multiple local projects share the same `stripe_subscription_id`.
- Accepted follow-up: enforce unique local `projects.stripe_subscription_id` mappings at the model/database layer so duplicate mappings fail at write time.

## Rationale
- `projects.stripe_subscription_id` is not locally unique, so selecting the first matching project could clear billing state on an arbitrary project.

## Expected Behavior
- If webhook cancellation matches more than one local project:
  - log an error
  - return `200`
  - report `reason=subscription_mapping_ambiguous`
  - leave all matched projects unchanged

## Verification
- Added focused webhook coverage for ambiguous local mappings in `tests/billing/test_stripe_webhook.py` using a mocked session result, because the new uniqueness constraint prevents creating duplicate mappings through the normal ORM path.
- Added migration/model coverage to ensure duplicate local subscription ids are rejected after migration 033.
