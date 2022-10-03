// For documentation on Fiberplane Templates, see: https://github.com/fiberplane/templates
local fp = import 'fiberplane.libsonnet';
local c = fp.cell;
local fmt = fp.format;

function(
  title='Your loki notebook 🚀 '
)
  fp.notebook
  .new(title)
  .setTimeRangeRelative(minutes=60)
  .addLabels({
  'type': 'starter-kit',
  })
  .addCells([
    c.text(['This is a preview notebook that shows logs within /var/logs on your host. Make sure to select ', fmt.bold(['my Loki as a datasource in the top right']), '. Happy troubleshooting!!!']),
    c.h3(['System Logs']),
    c.loki('{filename="/var/log/system.log"}'),
    c.h3(['All logs from varlogs']),
    c.loki('{job="varlogs"}')
  ])
  
