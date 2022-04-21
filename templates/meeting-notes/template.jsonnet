// For documentation on using Fiberplane Templates, see:
//   https://github.com/fiberplane/templates
local fp = import 'fiberplane.libsonnet';
local c = fp.cell;

function(
  // Any arguments to this function will be filled
  // in with values when the template is evaluated.
  //
  // You can replace fixed values anywhere in the
  // template with the argument names and the
  // values will be substituted accordingly.

  topic='<Topic>',
  date='<Date>',
)
  fp.notebook
  .new('Meeting Notes: ' + topic + ' - ' + date)
  .setTimeRangeRelative(60)
  .addLabels({})
  .addCells([
    c.text('Attendees:'),
    c.h1('Agenda'),
    c.listItem.ordered(' ', startNumber=1),
    c.listItem.ordered(''),
    c.h1('Notes'),
    c.listItem.unordered(' '),
    c.listItem.unordered(''),
    c.h1('Action Items'),
    c.checkbox(' ', checked=false),
    c.checkbox('', checked=false),
    c.text(''),
  ])
