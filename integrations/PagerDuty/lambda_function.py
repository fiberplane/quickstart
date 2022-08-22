'''
Documentation - https://docs.fiberplane.com/templates/pagerduty-integration
'''
import json
import requests #pick lambda runtime as py 3.7 for now, to be changed later on using a lambda layer with requests module in.

'''
Function to invoke fp trigger
'''
def post_to_fp(payload, fp_url):
    payload = json.dumps(payload)
    headers = {
        'content-type': 'application/json'
    }
    response = requests.request("POST", fp_url, headers=headers, data=payload)
    return(response.json())

'''
Function to write notes in pagerduty incident
'''
def post_to_pd(incident_id, notes, pd_api_key, userid):
    pd_url = f"https://api.pagerduty.com/incidents/{incident_id}/notes"
    payload = json.dumps({
        "note": {
            "content": notes
        }
    })
    headers = {
        'Accept': 'application/vnd.pagerduty+json;version=2',
        'Authorization': f'Token token={pd_api_key}',
        'Content-Type': 'application/json',
        'From': userid
    }
    response = requests.request("POST", pd_url, headers=headers, data=payload)
    return response.text

'''
Function to get user email from pagerduty, invoked only when there is no email passed in pagerduty webhook custom header.
'''
def get_pd_user(userid, pd_api_key):
    pd_url = f"https://api.pagerduty.com/users/{userid}"
    headers = {
        'Accept': 'application/vnd.pagerduty+json;version=2',
        'Authorization': f'Token token={pd_api_key}',
        'Content-Type': 'application/json'
    }
    user_details = requests.request("GET", pd_url, headers=headers).json()
    return(user_details['user']['email'])

'''
Function to post the notebook url to slack
'''
def post_to_slack(slack_wh,notebookUrl, pd_inc_url):
    payload = json.dumps({
        "type": "mrkdwn",
        "text": f":fire:Fiberplane <{notebookUrl}|notebook> created for <{pd_inc_url}| an incident> on your service:rotating_light:"
    })
    headers = {
        'Content-type': 'application/json'
    }
    response = requests.request("POST", slack_wh, headers=headers, data=payload)
    return response.text

def lambda_handler(event, context):
    payload = json.loads(event['body']) # get event details passed by pd from lambda request body
    trigger = event['headers']['fp-trigger'] # get fp trigger value from custom header passed by pagerduty
    pd_api_key = event['headers']['pd-apikey'] # get pd api key from custom header
    pd_incident = payload['event']['data']['id'] # get pd incident id
    pd_inc_url = payload['event']['data']['html_url'] # get pd incident url
    slack_wh = event['headers']['slack-webhook'] # get slack webhook
    if 'email' in event['headers']: # check if email is passed in custom headers, if yes, use it to write notes
        userid = event['headers']['email']
    else:
        pd_user = payload['event']['agent']['id'] # if email not in custom headers, get email id of user who ack the incident
        userid = get_pd_user(pd_user, pd_api_key)
    fp_details = post_to_fp(payload,trigger) # capture response from fp notebook creation
    notes = fp_details['notebookUrl'] # notebook url parsed off fp response
    post_to_pd(pd_incident, notes, pd_api_key, userid) # send it back to pd api to write as a note
    post_to_slack(slack_wh,fp_details['notebookUrl'],pd_inc_url) # post notebook url to slack

    return {
        'statusCode': 200,
        'body': json.dumps('Done stuff')
    }