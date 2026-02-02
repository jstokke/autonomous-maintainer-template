# Autonomous Maintainer Enabled

This repository uses an Autonomous Maintainer.

Any work item entering the system MUST either:
- Be implemented and merged automatically, or
- Fail loudly with explicit escalation.

Silent backlog accumulation is a system failure.

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
