"""A script to deploy to AWS Lambda to send requests to Slack channel via AWS ALB."""

import json
import urllib.request
import urllib.error

def lambda_handler(event, context):
    """Lambda event"""
    # Define the Slack webhook URL
    slack_webhook_url = "https://hooks.slack.com/workflows/test-url"

    # Define the payload data to send to Slack
    payload = {
        "text": "Hello from AWS Lambda!",
        "username": "Lambda Function",
        "channel": "#test-lambda"
    }

    # Convert the payload to JSON
    json_payload = json.dumps(payload).encode("utf-8")

    # Send the payload to Slack using HTTP POST
    try:
        req = urllib.request.Request(slack_webhook_url, data=json_payload, headers={"Content-Type": "application/json"})
        #Adding with statement to better handle system resources
        with urllib.request.urlopen(req, timeout=5):
            pass
    except urllib.error.HTTPError as http_issue:
        # Handle HTTP-related errors (e.g., 404, 500, etc.)
        print(f"HTTP Error: {http_issue.code}, {http_issue.reason}")

    except urllib.error.URLError as url_issue:
        # Handle URL-related errors (e.g., connection issues, timeout, etc.)
        print(f"Error when making the request: {url_issue}")

    except Exception as other_issues:
        # Handle any other unexpected exceptions
        print(f"An unexpected error occurred: {other_issues}")

    # Return the HTML response while invoking ALB
    return {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": "<h1>Hello from Lambda!</h1>"
    }
