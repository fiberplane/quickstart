<div align="center">
  <img alt="Fiberplane Logo" src="assets/fp-logo.png" height="100"/>
  <h1>Quickstart Fiberplane</h1>
  <hr style="border-width: 0.25em"></hr>
</div>

Fiberplane is a collaborative notebook that connects to your observability stack and helps you monitor and debug your infrastructure. Fiberplane is currently available for the Web in closed beta - you can sign up for early access 👉 **[here](https://fiberplane.dev)**.

You can explore a Fiberplane Notebook by simply going to [fp.new](https://fp.new) in the address bar of your browser, however, in order to save your notebook or query your observability data you will need to create an account and establish access to your infrastructure.

### How Fiberplane works

Fiberplane accesses your infrastructure through Proxy, a lightweight package, [available as a Docker image](https://hub.docker.com/r/fiberplane/proxy), that once installed allows you to query your observability data from your Notebook.

Whenever you execute a query in the notebook:

1. The query is forwarded to the Fiberplane Proxy in your cluster;
2. The Proxy then queries the data source (e.g. your Prometheus or Elastic instance);
3. The Proxy processes, encrypts, and then returns the data back to the Studio.

\***Note:**\* Fiberplane Proxy is currently optimized to work with Kubernetes and Prometheus. Elasticsearch, Loki and more providers are coming soon.

This guide will walk you through how to set up the Fiberplane Proxy and install it in your Kubernetes cluster or run it locally for testing purposes.

#### What is in this repo?

<table>
<tr>
    <td>./proxy-kubernetes</td>
    <td>Sample YAML files to configure and deploy the Fiberplane Proxy to your Kubernetes cluster </td>
</tr>
<tr>
    <td>./proxy-local</td>
    <td>Sample YAML configuration to deploy the Fiberplane Proxy locally</td>
</tr>
</table>

## ⚡️ Setting up the Fiberplane Proxy with the CLI

### Step 1: Download the Fiberplane CLI (beta)

1. Download the latest `fp` binary release with cURL using one of the options below:

#### Mac (Apple Silicon):
 ```shell
 curl -O https://fp.dev/fp/latest/macos_aarch64/fp
 ```
#### Mac (Intel):
```shell
curl -O https://fp.dev/fp/latest/mac_x86_64/fp
```
#### Linux / Windows (WSL): 
```shell
curl -O https://fp.dev/fp/latest/linux_x86_64/fp
```

2. Make the `fp` binary executable:

```shell
chmod 700 ./fp
```

Optional: add the binary to your PATH so you can access it by simply typing `fp` in your prompt.

### Step 2: Authenticate the CLI

You will need to authenticate the downloaded CLI with your Fiberplane account so you can create and register the Proxies. Simply type:
```shell
fp login
```

You will be then prompted to login with your account. When you complete the login you can safely close the window.

You can now access your Fiberplane Notebooks through the CLI (see reference for some of the basic available commands)!

### Step 3: 

### Contents

* **[1. Register the proxy with Fiberplane Studio](#1-register-the-proxy-with-fiberplane-studio)**
* **[2a. Deploy the proxy to your Kubernetes cluster (recommended)](#2a-deploy-the-proxy-to-your-kubernetes-cluster-%28recommended%29)**
* [2b. Run the proxy locally for testing](#2b-run-the-proxy-locally-for-testing)

### 1. Register a Proxy with Fiberplane Studio

In order for the Proxy to talk to the Fiberplane Studio successfully it needs to be successfully authorized. This step will generate a *Proxy API Token* that will be needed later.

1. Go to your Fiberplane [Settings page](https://fiberplane.com/settings).
2. Click **`+ New Proxy`** to register a proxy with a name that identifies the cluster you will install it into (for example, "Production"). This will generate and display a Proxy API Token that the proxy will use to authenticate with the Fiberplane Studio.
3. Copy the Proxy API Token generated in Step 2 for the next step.

You can now deploy the Proxy to your cluster or run it locally for testing.

### 2a. Deploy the proxy to your Kubernetes cluster (recommended)

>💡 **Tip: check out the `./proxy-kubernetes` directory in this repo for example YAML configurations.**

1. Create the Kubernetes configuration file and change the Prometheus URL to point to the Prometheus instance(s) inside your cluster. See example file in `proxy-kubernetes/configmap.yaml`
2. Create the Kubernetes deployment file (replace `<proxy_api_token>` with the Proxy API token created during the proxy registration step). See example file in `proxy-kubernetes/deployment.yaml`
3. Apply the changes to your Kubernetes cluster by running the following commands:

```shell
kubectl apply -f configmap.yml
kubectl apply -f deployment.yml
```
4. Kubernetes will automatically download, install, and configure the Fiberplane Proxy container from the [Docker Hub](https://hub.docker.com/r/fiberplane/proxy).


### 2b. Run the proxy locally for testing

> **Note: this option is only recommended for testing purposes. If you intend to run the Proxy in production, it is strongly recommended to install it in your production cluster (see instructions above).**

1. Make sure you have [Docker](https://docs.docker.com/get-docker/) installed.
2. Create a `data_sources.yaml` in the root directory. Use the template provided at `proxy-local/data_sources.yaml`
3. Run the following command replacing `<proxy_api_token>` with the Proxy API Token created earlier:
	```shell
	docker run \
	  -v "$PWD/data_sources.yaml:/app/data_sources.yaml" \
	  fiberplane/proxy:v1.1.2 \
	  --auth-token=<proxy_api_token>`
	```

Once you complete your Proxy setup, your data sources linked in the Proxy configuration should be recognized by the Studio - you can verify this again by going to the **Settings** screen.👇

![List of data sources in settings](assets/proxy-datasource.png)

## Feedback and support

We're always looking to improve our onboarding experience! Please report any issues and share your feedback by:

* submitting a Github issue;
* messaging us on Slack, we're active there (email [support@fiberplane.com](mailto:support@fiberplane.com) for an invite);
* emailing us at [support@fiberplane.com](mailto:support@fiberplane.com).
