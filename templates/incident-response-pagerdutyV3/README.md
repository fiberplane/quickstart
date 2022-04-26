# [Incident Response with Pagerduty Template](./template.jsonnet)

> A template that can be used and / or altered to provide a consistent response to incidents.

## Template Documentation

This is an example template that illustrates how Fiberplane can work with your alert manager to aid your incident response workflow. This template works with the PagerDuty Webhook integration (V3) that sends a trigger when the incident is acknowledged in PagerDuty.

Setup the workflow: 0. (prerequisite) make sure you have the Fiberplane CLI installed;

1. Pull down this repo;
2. Add the local template jsonnet file to your Fiberplane:
   $ fp templates create --title="Name of your template" /path/to/the/template.jsonnet
   -> copy the ID of the template
3. Create a trigger endpoint for the template:
   $ fp triggers create --title="Name of your trigger endpoint" --template-id=YOUR_TEMPLATE_ID
4. Grab the generated URL with the secret key and paste it to PagerDuty Webhook setup
