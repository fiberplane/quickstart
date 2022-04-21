# [Incident Analysis / Postmortem Template](./template.jsonnet)

> A template that can be used to guide teams through the incident analysis / postmortem process, focussing on the learnings gained from the incident.

## Template Documentation

### Template Arguments

The template has four arguments which can be used to provide context for the incident being analysed. These are:

-   `incidentNumber` - This will add the incident number to the title of the notebook. Default value is `<Incident Number>`
-   `incidentTitle` - This will add the incident name to the title of the notebook. Default value is `<Incident Title>`
-   `serviceName` - This will populate the value for the label with the key `service` with the name of the service. Default value is `service_name`
-   `environmentName` - This will populate the value for the label with the key `environment` with the name of the environment. default value is `environment_name`

### Time Range

The template defaults to the last hour. Change the value of `.setTimeRangeRelative(minutes=60)` to edit this
