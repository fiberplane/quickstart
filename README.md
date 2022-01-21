<div align="center">
  <img alt="Fiberplane Logo" src="assets/fp-logo.png" height="200"/>
  <br>
  <div align="center">
    <a href="https://twitter.com/fiberplane">
      <img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/fiberplane?style=flat-square&color=4797FF&logo=twitter" height="25" width="auto">
    </a>
  </div>

<br>

  <h1>Quickstart Fiberplane</h1>

</div>

Fiberplane Studio is available for the [Web](https://fiberplane.com/) (macOS and Linux desktop applications coming soon).

To get started go to [https://fiberplane.com/](https://fiberplane.com/) and log in with your Fiberplane account (currently available only for Google with Workspace users). You can also go right away to your notebook by typing [fp.new](https://fp.new) in your URL, however, to save and store your notebook, you will need to log in.

## How Fiberplane works

Fiberplane Studio allows you to query, visualize, and understand metrics and logs in your infrastructure. 

Whenever you execute a query in the notebook:

1. The query is forwarded to the Fiberplane Proxy in your cluster;
2. The Proxy then queries the data source (e.g. your Prometheus or Elastic instance);
3. The Proxy processes, encrypts, and then returns the data back to the Studio.


## Set up Fiberplane Proxy

The Fiberplane Proxy is a package that runs in your infrastructure. It enables you to connect the Fiberplane Studio to data sources in your cluster(s) securely without exposing them to the Internet.

The Fiberplane Proxy is available as a [container on Docker Hub](https://hub.docker.com/r/fiberplane/proxy).

### Contents

* **[1. Register the proxy with Fiberplane Studio](#1-register-the-proxy-with-fiberplane-studio)**
* **[2a. Deploy the proxy to your Kubernetes cluster (recommended)](#2a-deploy-the-proxy-to-your-kubernetes-cluster-%28recommended%29)**
* [2b. Run the proxy locally for testing](#2b-run-the-proxy-locally-for-testing)

### 1. Register a Proxy with Fiberplane Studio

In order for the Proxy to talk to the Fiberplane Studio successfully it needs to be successfully authorized. This step will generate a *Proxy API Token* that will be needed later.

![Register a proxy](assets/proxy-register.png)

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
