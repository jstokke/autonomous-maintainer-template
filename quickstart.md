# Quickstart

This guide shows how to use this Autonomous Maintainer template in another repository.
It assumes no prior knowledge of GitHub features.

## What this gives you
- An issue template that captures acceptance criteria and constraints.
- GitHub Actions workflows that validate issues, enforce invariants, and auto-merge.
- Bash scripts that power the automation and can be run locally.

## Step-by-step setup
1. Create or choose a GitHub repository.
   - Go to https://github.com and create a new repository, or open an existing one.

2. Enable GitHub Actions for the repository.
   - Open your repository on GitHub.
   - Click Settings.
   - In the left sidebar, click Actions, then General.
   - Choose Allow all actions and reusable workflows, then click Save.

3. Copy this template into your repository.
   - Copy the `.github/` folder and the `scripts/` folder from this repo.
   - If you are using git locally, you can copy the folders and commit them.

4. Customize your invariants.
   - Edit `.github/invariant-rules/invariants.md` to match your rules.
   - Update `scripts/check-invariants.sh` with the checks you want enforced.

5. Create the required labels in your repository.
   - In GitHub, open Issues, then Labels, then click New label.
   - Create these labels:
     - autonomous
     - backlog
     - deferred-by-design-review
     - needs-human
     - autonomous-pr-opened

6. Install the GitHub CLI and sign in.
   - Install `gh` from https://cli.github.com/
   - Run `gh auth login` and follow the prompts.

7. Create your first backlog item using the template.
   - Open Issues, click New issue, then pick "Autonomous Backlog Item".
   - Fill out every section, especially Acceptance Criteria and Constraints.

8. Add the `autonomous` label to the issue.
   - This label triggers the automation workflows.

9. Watch the automation run.
   - Open the Actions tab in GitHub.
   - You should see issue validation and PR automation workflows run.

10. Hook in your autonomous agent.
   - Open `.github/workflows/autonomous-pr.yml`.
   - Replace the placeholder step with your agent invocation.

## Local testing (optional)
- Run `./scripts/run-tests.sh` to execute the script tests.
- Run `./scripts/validate-issue.sh` with `ISSUE_NUMBER` and `GH_TOKEN` set.
- Run `./scripts/check-invariants.sh` with `BASE_REF` set when needed.

## Troubleshooting
- If a script says a required variable is missing, set it in your environment.
- If `check-invariants.sh` cannot find the base branch, set `BASE_REF` or fetch the branch.
- If Actions cannot run, re-check that Actions are enabled in repository settings.