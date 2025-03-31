# Data Fetcher App

This is an app that is configurable to retrieve and send data to APIs. This can handle multiple sources, multiple types of authentication, request types and parsing mechanisms (storage + actions). This can continue to adapt to our needs. Designed to run as a container instance with an open listener on an Azure Service Bus Queue for messages & instructions for requests to make.

# Common Packages

`export COMMON_PACKAGE_PATH=../common`

# Locally run

All runs should be done at the context of the root of the repo.

To run via CLI

```
cd ..
pip install -r ./3_Applications/data-fetcher/requirements.txt
python ./3_Applications/data-fetcher/src/main.py
```

To run in Container:

```
podman build -t data-fetcher .
podman run -v $HOME/.azure:/home/myuser/.azure --name data-fetcher -e ENVIRONMENT=sbox data-fetcher
```

To add your local Azure CLI authentication for local container runs, add the following:

```
podman run -v $HOME/.azure:/home/myuser/.azure --name data-fetcher -e ENVIRONMENT=sbox data-fetcher
```

To scale the application, you can run multiple containers with the compose file:

```
podman compose --file compose.yaml up --scale data-fetcher=3 --detach
```

Note, this requires read access to the AKV credential store, Azure Service Bus Data Sender & Azure Service Bus Data Receiver roles to the target Service Bus Queue.
