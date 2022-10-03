// For documentation on Fiberplane Templates, see: https://github.com/fiberplane/templates
local fp = import 'fiberplane.libsonnet';
local c = fp.cell;
local fmt = fp.format;

function(
  title='Your prometheus + loki notebook 🚀 '
)
  fp.notebook
  .new(title)
  .setTimeRangeRelative(minutes=15)
  .addLabels({
  'type': 'starter-kit',
  })
  .addCells([
    c.text(['This is a preview notebook that shows basic infrastructure data & logs from the Prometheus and Loki instances you just set up using the Starter Kit. Make sure to select ', fmt.bold(['my Prometheus & my Loki as datasources in the top right']), '. Happy troubleshooting!!!']),
    c.h3('Prometheus health check'),
    c.prometheus('up'),
    c.h3('CPU usage'),
    c.prometheus('(1 - avg(irate(node_cpu_seconds_total{mode="idle"}[1m])) by (instance)) * 100'),
    c.h3('Memory usage'),
    c.prometheus('(node_memory_MemTotal_bytes/1024/1024/1024) - (node_memory_MemAvailable_bytes/1024/1024/1024)'),
    c.h3('Disk usage'),
    c.prometheus('100 - ((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes)'),
    c.h3(['Total HTTP Requests', fmt.bold([])]),
    c.prometheus('rate(prometheus_http_requests_total[1m])'),
    c.h3(['System Logs']),
    c.loki('{filename="/var/log/system.log"}'),
    c.h3(['All logs from varlogs']),
    c.loki('{job="varlogs"}'),
    c.h1('Next Steps'),
    c.text(['Now proceed to instrumenting your application to get metrics from your app. Prometheus provides client libraries in different languages to make it easier for you, find out more ', fmt.link(url='https://prometheus.io/docs/instrumenting/clientlibs/#', content=['here']), '.']),
  ])
  
