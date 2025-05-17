#!/bin/bash
set -e

BODY=$(echo "$PR_BODY" | tr -d '\r')

TICKET_ID=$(echo "$BODY" | grep -oE 'https://[a-zA-Z0-9.-]+/browse/([A-Z]+-[0-9]+)' | grep -oE '[A-Z]+-[0-9]+')

if [ -z "$TICKET_ID" ]; then
  echo "❌ No Jira ticket found in PR body. Skipping transition."
  exit 0
fi

echo "✅ Jira Ticket ID detected: $TICKET_ID"
echo "🚀 Sending transition request to Jira..."

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --url "${JIRA_BASE_URL}/rest/api/3/issue/${TICKET_ID}/transitions" \
  -d "{\"transition\": {\"id\": \"${JIRA_TRANSITION_ID}\"}}")

if [ "$RESPONSE" == "204" ]; then
  echo "✅ Jira issue $TICKET_ID transitioned successfully."
else
  echo "❌ Jira transition failed. HTTP response: $RESPONSE"
  exit 1
fi
