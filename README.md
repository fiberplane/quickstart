<div align="center">
  <img alt="Fiberplane Logo" src="assets/fp-logo.svg" height="75"/>
  <hr style="border-width: 0.25em"></hr>
</div>

Fiberplane is a collaborative notebook that connects to your observability stack and helps you monitor and debug your infrastructure. Fiberplane is currently available for the Web in closed beta - you can sign up for early access 👉 **[here](https://fiberplane.dev)**.

You can explore a Fiberplane Notebook by simply going to [fp.new](https://fp.new) in the address bar of your browser, however, in order to save your notebook or query your observability data you will need to create an account and establish access to your infrastructure.

### How Fiberplane works

Fiberplane accesses your infrastructure through Proxy, a lightweight package, [available as a Docker image](https://hub.docker.com/r/fiberplane/fpd), that once installed allows you to query your observability data from your Notebook.

Whenever you execute a query in the notebook:

1. The query is forwarded to the Fiberplane Proxy in your cluster;
2. The Proxy then queries the data source (e.g. your Prometheus or Elastic instance);
3. The Proxy processes, encrypts, and then returns the data back to the Studio.

\***Note:**\* Fiberplane Proxy is currently optimized to work with Kubernetes and Prometheus. Elasticsearch, Loki and more providers are coming soon.

## ⚡️ Setting up the Fiberplane Proxy with the CLI

This guide will walk you through how to set up the Fiberplane Proxy and install it in your Kubernetes cluster or run it locally for testing purposes.

#### What is in this repo?

<table>
<tr>
    <td>integrations/</td>
    <td>Available plugins that can work with Fiberplane Templates</td>
</tr>
<tr>
    <td>starter-kits/</td>
    <td>Sample docker-compose files to start up your Prometheus, Elasticsearch, Loki instances</td>
</tr>
<tr>
    <td>templates/</td>
    <td>Sample Fiberplane templates to help get you started building workflows</td>
</tr>
</table>

### Pre-requisite: Download the Fiberplane CLI (beta)

To work with Fiberplane Templates and setup Providers you will need to install the Fiberplane CLI. You can download and install `fp` with one command:

Either Homebrew:

```bash
brew install fiberplane/tap/fp
```

or install script:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://fp.dev/install.sh | sh
```

<details>
<summary><strong>Alternatively: Download the latest binaries directly with cURL (click to expand)</strong></summary>

Mac (Apple Silicon):

```shell
curl -O https://fp.dev/fp/latest/aarch64-apple-darwin/fp
chmod 755 ./fp
```

Mac (Intel):

```shell
curl -O https://fp.dev/fp/latest/x86_64-apple-darwin/fp
chmod 755 ./fp
```

Linux / Windows (WSL):

```shell
curl -O https://fp.dev/fp/latest/x86_64-unknown-linux-gnu/fp
chmod 755 ./fp
```

</details>

### Step 1: Authenticate the CLI

You will need to authenticate the downloaded CLI with your Fiberplane account so you can create and register the Proxies. Simply type:

```shell
fp login
```

You will be then prompted to login with your account. When you complete the login you can safely close the window.

### Step 2: Register an `fpd` (Fiberplane Daemon) with Fiberplane

In order for `fpd` to receive queries from Fiberplane Notebooks, it needs to be authorized. This step will generate a **Daemon API Token** that will be needed in later steps.

To register an `fpd` run a command `fp daemon create`:

```
$ fp daemon create
Added proxy "robust-antelope" # generates a random name
Proxy API Token: XXX_XX # and a token - save this for later!
```


### Step 3: Run the Daemon locally for testing

1. Make sure you have [Docker](https://docs.docker.com/get-docker/) installed.
2. Create a `data_sources.yaml` in the current directory in the following format:

```yaml
# data_sources.yaml
#
# Replace the following line with the name of the data source
- name: prometheus-prod
  description: Prometheus (Production)
  providerType: prometheus
  config:
    # Replace the following line with your Prometheus URL
    url: http://prometheus
```

<!--markdownlint-disable-next-line-->
3. Run the following command replacing `<FPD_API_TOKEN>` with the `fpd` API Token created earlier:

```bash
docker run \
  -v "$PWD/data_sources.yaml:/app/data_sources.yaml" \
  fiberplane/fpd:v2 \
  --token=<FPD_API_TOKEN>
```

## Feedback and support

We're always looking to improve our onboarding experience! Please report any issues and share your feedback by either:

- emailing us at [support@fiberplane.com](mailto:support@fiberplane.com).
- submitting an issue here on Github.
