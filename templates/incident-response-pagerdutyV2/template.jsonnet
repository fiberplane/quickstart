// This is an example template that illustrates how Fiberplane can work with your alert manager to aid your incident response workflow. This template works with the PagerDuty Webhook integration (V3) that sends a trigger when the incident is acknowledged in PagerDuty.
//
// To activate it:
//
// 0. (prerequisite) make sure you have the Fiberplane CLI installed;
// 1. Pull down the repo and navigate to the template folder;
// 2. Add the local template jsonnet file to your Fiberplane:
//    $ fp templates create --title="Name of your template" /path/to/the/template.jsonnet
//    -> copy the ID of the template
// 3. Create a trigger endpoint for the template:
//    $ fp triggers create --title="Name of your trigger endpoint" --template-id=YOUR_TEMPLATE_ID
// 4. Grab the generated URL with the secret key and paste it to PagerDuty Webhook setup

local fp = import 'fiberplane.libsonnet';
local c = fp.cell;
local fmt = fp.format;

function(
  title='Pagerduty Incident - Webhook V2',
  messages=[], //PagerDuty sends an array of objects in v2 of the webhook
)
  fp.notebook
  .new('Incident ' + messages[0].incident.incident_number + ' - ' + messages[0].incident.title + ' on ' + messages[0].incident.impacted_services[0].summary)
  .setTimeRangeRelative(60) // sets time range to the 1h until the notebook has been created
  //
  // You can preselect the data sources for the notebook with the lines below (uncomment to use)
  //
  //.addDirectDataSource(
  //   type='prometheus',
  //   name='default',
  //   url='https://url.to.your.prometheus',
  // )
  //
  // .addProxyDataSource(type='prometheus')
  //
  .addLabels({ // we're also setting in some metadata that will help us organize the notebook
    'incident':null, //shows that this notebook is for an incident
    'status':messages[0].incident.status, //shows the status of the incident (usually:triggered)
    'service':messages[0].incident.impacted_services[0].summary, //provides the name of the service NOTE THAT THIS WILL NOT DISPLAY IF THE SERVICE NAME HAS CHARACTERS NOT ALLOWED IN LABELS
    'severity':messages[0].incident.urgency, // grabs the urgency
  })
  .addCells([
    c.text([fmt.bold(['Incident ID: ']), fmt.code([messages[0].log_entries[0].incident.id])]), //Pagerduty incident ID
    c.text(['Assigned to: ', messages[0].incident.assignments[0].assignee.summary]), //shows who the incident is assigned to, as per the Pagerduty escalation policy and schedule for the service
    c.h3('Summary'),
    c.text(''),
    c.divider(readOnly=true),
    c.h3(fmt.bold('Timeline')),
    c.text(messages[0].incident.created_at + ' - Incident start time'),
    c.divider(readOnly=true),
    c.h3('Actions'),
    c.checkbox('Action 1', checked=false),
    c.text(''),
  ])