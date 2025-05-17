# Jira Transition GitHub Action

Automatically transitions a Jira issue (e.g., to QA) when a pull request is merged into the `develop` branch. The Action extracts the Jira ticket from the PR body and triggers a Jira transition via the REST API.

---

## 🔐 Required GitHub Secrets

| Secret Name             | Description                          |
|-------------------------|--------------------------------------|
| `JIRA_BASE_URL`         | Base URL of your Jira instance (e.g., https://yourcompany.atlassian.net) |
| `JIRA_EMAIL`            | Email used to authenticate with Jira |
| `JIRA_API_TOKEN`        | Jira API token                       |
| `JIRA_TRANSITION_ID`    | Jira transition ID for the specific state  |

---

## Jira Link Format Requirement

This Action extracts the Jira issue key from the pull request body by matching Jira issue URLs.
The Jira issue link must be included in the PR body and should follow this URL pattern:

```
Implemented new validation logic.

Related Jira Ticket:  
https://yourcompany.atlassian.net/browse/PROJ-123


```

## ✅ Usage Example

```yaml
name: Transition Jira Issue to QA

on:
  pull_request:
    types:
      - closed

jobs:
  transition:
    if: github.event.pull_request.merged == true && github.event.pull_request.base.ref == 'develop'
    runs-on: ubuntu-latest
    steps:
      - uses: kiranka123/jira-transition-action@v1
