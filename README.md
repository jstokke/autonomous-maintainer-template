# Autonomous Maintainer Enabled

This repository uses an Autonomous Maintainer to keep work moving without silent backlog.

Any work item entering the system MUST either:
- Be implemented and merged automatically, or
- Fail loudly with explicit escalation.

Silent backlog accumulation is a system failure.

## Quickstart
See [quickstart.md](quickstart.md) for step-by-step setup in another repository.

## Prerequisites
- GitHub repository with Actions enabled
- GitHub CLI (`gh`) installed and authenticated
- Bash and git

## How Work Enters the System
- Design reviews
- Backlog items
- Deferred improvements

All deferred items MUST be GitHub Issues with:
- Acceptance criteria
- Constraints
- Explicit ownership

## When Humans Are Involved
Humans are only required when:
- Acceptance criteria are unclear
- Invariants are violated
- Autonomous retries are exhausted

Everything else is handled automatically.

## Scripts
- `./scripts/validate-issue.sh` validates issue format. Requires `ISSUE_NUMBER` and `GH_TOKEN`.
- `./scripts/check-invariants.sh` enforces invariant rules. Optional `BASE_REF` controls diff base.
- `./scripts/retry-budget.sh` labels issues after retry limits. Requires `PR_NUMBER`, `ISSUE_NUMBER`, `GH_TOKEN`.
- `./scripts/run-tests.sh` runs the local test suite.
