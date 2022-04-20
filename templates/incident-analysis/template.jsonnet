local fp = import 'fiberplane.libsonnet';
local c = fp.cell;
local fmt = fp.format;

function(
  // Any arguments to this function will be filled
  // in with values when the template is evaluated.
  //
  // You can replace fixed values anywhere in the
  // template with the argument names and the
  // values will be substituted accordingly.

  incidentNumber='<Incident Number>',
  incidentTitle='<Incident Title>',
  serviceName='service_name',
  environmentName='environent_name',

)
  fp.notebook
  .new('Incident Analysis: ' + incidentNumber + ' - ' + incidentTitle)
  .setTimeRangeRelative(minutes=60)
  .addLabels({
    type: 'incident-analysis',
    service: serviceName,
    environment: environmentName,
  })
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
  .addCells([
    c.h1('Incident Overview'),
    c.text(fmt.italics('A summary of the incident. How did it start? What happened? You can add a timeline in the timeline section at the end of the document so keep this brief')),
    c.h1('Impact'),
    c.text(fmt.italics('What was the impact? Did users get errors when performing certain actions? Was there a total loss of service? How long was this for? Use graphs to show this for context')),
    c.h1('Contributing factors'),
    c.text(fmt.italics("An incident occurs as the result of a sequence of events, it's rarely one thing. All contributing causes should be listed here. It's important that these are free of blame on people or teams. Focus on what happened, how the incident occurred and the processes followed in resolving it E.g")),
    c.listItem.unordered("'an incorrect configuration was applied'"),
    c.listItem.unordered("'the application hit a thread deadlock scenario' "),
    c.listItem.unordered("'the application only runs in one region'"),
    c.listItem.unordered("'High load uncovered a memory leak that occurs when users perform action X' "),
    c.listItem.unordered("'Application servers were no longer available'"),
    c.listItem.unordered("'Our infrastructure host suffered a failure'"),
    c.h1('What did we learn?'),
    c.text(fmt.italics("Incidents are one of the best opportunities for an organisation to learn so it's important to consider what you can learn from this incident. Consider the following questions as you walk through the timeline")),
    c.listItem.unordered('Did the existing processes provide adequate protection to prevent failure scenarios?'),
    c.listItem.unordered('Were the incident responders adequately equipped to deal with the incident?'),
    c.listItem.unordered('How did we identify what was happening? '),
    c.listItem.unordered('Was it easy to get to this understanding?'),
    c.listItem.unordered('What was our thinking when we took this action?'),
    c.listItem.unordered('What would we do differently if we came across this incident again?'),
    c.listItem.unordered('What went well? How can we emphasise this in future incidents?'),
    c.h1('Actions'),
    c.text(fmt.italics('List any actions that can be taken to build upon the learnings. Ideally get these assigned and added to any system you use for tracking planned work e.g linear, JIRA etc')),
    c.listItem.unordered('Action 1'),
    c.listItem.unordered('Action 2...'),
    c.divider(),
    c.h1('Timeline'),
    c.text(fmt.italics('This section should contain a timeline of the events of this incident. This should cover when the incident started, when you became aware and then a factual list of key events up to the incident resolution.')),
    c.h1('Fix'),
    c.text(fmt.italics('List the actions taken that remediated this incident')),
  ])
