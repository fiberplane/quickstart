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
  title='PagerDuty Incident - Webhook V3',
  event={}, // PagerDuty sends the Webhook payload as a JSON object
)
  fp.notebook
  .new('Incident #' + event.data.number + ': ' + event.data.title + ' - ' + event.data.service.summary,)
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
    'type': event.data.type, // gets the type of the event (usually: incident)
    'service-id': event.data.service.id, // gets the id of the service as specified in PagerDuty
    'priority': event.data.priority.summary, // P1, P2 etc. Make sure you have Priorities enabled on PagerDuty
    'urgency': event.data.urgency, // grabs the urgency 
    'status': event.data.status, // grabs the status of the incident from PagerDuty (usually: acknowledged)
  })
  .addCells([
    c.text([fmt.bold(['PagerDuty URL: ']), event.data.html_url]), // link back to the incident on PagerDuty
    c.text([fmt.bold(['Incident ID: ']), fmt.code([event.data.id])]),
    c.text([fmt.bold(['Assigned to: ']), event.data.assignees[0].summary,]), //shows who the incident is assigned to, as per the Pagerduty escalation policy and schedule for the service
    c.h3('Summary'),
    c.text(''),
    c.divider(readOnly=true),
    c.h3(fmt.bold('Timeline')),
    c.text(event.data.created_at + ' - Incident triggered'),
    c.text([fmt.highlight([event.occurred_at]), ' - Incident acknowledged (by: ', event.agent.summary, ')']),
    c.divider(readOnly=true),
    c.h3('Actions'),
    c.checkbox('Action 1', checked=false),
    c.text(''),
  ])