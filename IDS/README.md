# InterSystems Data Studio in a Box

InterSystems Data Studio can run as a Smart Data Service in Kubernetes or as a set of individual containers running as a docker composition on your local PC. 

This guide will help you deploy InterSystems Data Studio on your local PC using docker and a docker compose file. 

Here is what you will need:
* If you are using Windows, **you must** [install Git](https://git-scm.com/download/win) and use GitBash as your shell (instead of cmd or powershell). **Make sure you start GitBash as an administrator!**
* A machine with at least 32GiB of RAM and 8 physical cores (16 logical cores)
* Docker installed on your machine configured to have access to at least 10 GiB of RAM and 8 logical cores
* Licenses and Credentials you must get from InterSystems:
  * An IRIS Advanced Server License (server license, not concurrent user license) - You can get one from the [Evaluation Service](https://evaluation.intersystems.com). Make sure you get a license for **InterSystems IRIS Advanced Server Running on Ubuntu Containers for x86**.
  * An account with InterSystems so you can access our container registry at https://irepo.intersystems.com

Feel free to ask your **Sales Engineer** to help you with the technical requirements above if you have any issues.

You may also need to reach out to your **Sales Executive** to obtain the required license for InterSystems IRIS. 

**THIS COMPOSITION IS FOR EVALUATION PURPOSES ONLY. IT SHOULD NOT BE INSTALLED ON PRODUCTION SYSTEMS.**

# Versions of softwares on Data Studio:

This version of Data Studio uses IRIS 2025.1.3.

# Inventory of files and scripts you can use

Here is a description of the contents of this repository that are useful to you:

| Component                     | Description                                                                                                                   |
|-------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| `start.sh`                    | Script used to start the three images as new containers by using the composition defined in the `./docker-compose.yaml` file. |
| `logs-*.sh`                   | There are four scripts that start with `logs`. They will allw you to pull all the logs (`logs-all.sh`), logs just for iris (`logs-iris.sh`), etc. |
| `stop.sh`                     | Script used to stop the composition defined in the `./docker-compose.yaml` file. You can use the `./start.sh` script to resume it later and continue your work from where you stopped. |
| `remove.sh`                   | Script used to remove the containers of the composition and purge the durable folders of IRIS and IRIS Adaptive Analytics. This script can be used after switching to another branch in this Git repository so that your images will be rebuilt with the code from that branch. That is why we need to dispose of the durable data saved outside the containers. This script can also be run when the user needs to clean the durable data saved outside the container in order to start clean in the same branch. |
| `logs.sh`                     | Script used to follow the logs of the running composition. |
| `VERSION`                     | File that contains the version of the product on the current branch |
| iris-volumes/DurableSYS       | This is where the `dur` folder of Durable %SYS of InterSystems IRIS will be created when the container starts. That is what allows you to stop/start your containers without losing your data. |
| ./iris-volumes/files-dir       | When using Data Studio FileDir Data Source connector, you will be able to see your file dir data sources folders being created here. You will also be able to drop files on the `Samples` and `Source` folders to test adding them to the Data Studio data catalog ingesting them on a Data Studio Recipe |
| `CONF_IRIS_LOCAL_WEB_PORT`    | Local port used to reach the IRIS management portal. Default is 42773 which means that the management portal will be at http://localhost:42773/csp/sys/UtilHome.csp |
| `CONF_IRIS_LOCAL_JDBC_PORT`   | Local port used to reach the IRIS SuperServer. Default is 41972. Which means that the default JDBC URL will be jdbc:IRIS://localhost:41972/B360 |
| `CONF_FRONTEND_LOCAL_PORT`    | Local port used to reach the Angular UI Frontend. Default is 8081. Which means that the angular UI will be at http://localhost:8081 |
| `CONF_DOCKER_SUBNET`          | The IPv4 subnet to be used when creating the docker network for this docker-compose project. The default is 172.20.0.0/16. If IRIS Adaptive Analytics is not starting, it may be because you are using a "bad subnet". |
| `CONF_DOCKER_GTW`             | The IPv4 gateway to be used when creating the docker network for this docker-compose project The default is 172.20.0.1. |


# Starting the Data Studio composition

Make sure you pick the right IRIS license for your platform. If your machine is a Mac M1/M2, you will need an ARM IRIS license and it must be put on the file `./licenses/iris.key`.

In order to start InterSystems Data Studio (frontend, iris and iris adaptive analytics), run the `./start.sh` script.

The composition will start in the background. You can use the `logs-all.sh` script to follow its logs. This script will show you the logs of the two containers running. If you want to look at the logs of a specific container, call the appropriate `logs-*.sh` script for it.

The frontend should start very quickly, but it needs InterSystems IRIS to be running in order for it to work. So if you are in a hurry, you may want to use the `logs-iris.sh` to follow the InterSystems IRIS logs. The following message will be the indicator that you can open Data Studio and start working with it:

```
[INFO] ...started InterSystems IRIS instance IRIS
```

OBS: You can ignore some errors that follow the message above about RabbitMQ and the pika library.

Here is the list of endpoints and credentials that you can use:

| What | Where | Username | Default Password |
|-------------------------|---------------------------------------------|-------------|-------|
| IRIS Management Portal  | http://localhost:42773/csp/sys/UtilHome.csp | SuperUser   | sys   |
| InterSystems Data Studio| http://localhost:8081                       | SystemAdmin | sys   |
| JDBC Access to IRIS     | jdbc:IRIS://localhost:41972/B360            | SystemAdmin | sys   |

  
# Connecting to Data Studio using JDBC

We recommend using [DBEaver](https://dbeaver.io/download/) to connect to Data Studio and work on your target data model. DBEaver brings the InterSystems IRIS JDBC driver already and you should be able to install it and get it connected to InterSystems IRIS in no time.

It is possible to access the InterSystems IRIS Management Portal but you should avoid it and there should be no need for that. Data Studio will actually let you use a small portion of the InterSystems IRIS Management Portal (the SQL Explorer) from inside Data Studio itself. You should never need to open up the InterSystems IRIS Management Portal directly.

For JDBC, use the 'SuperUser' credentials mentioned above.

# Stopping the Data Studio Composition

You can use the `./stop.sh` script to bring the three containers down and pause them. This will not remove their durable data. You should be able to resume the work by running the `./start.sh` script again.

# Removing containers and durable data (DANGER!)

**WARNING: You can lose your data if you run this procedure!**

You can use the `./remove.sh` script to stop your containers, **remove them and purge their durable data**. This means all your data and configuration will be lost. This procedure is useful if you want a fresh start.

# Connecting using VSCode

This composition is exposing the IRIS Web Server Port at your local port 42773. You can add the following settings to your VSCode IRIS configuaration to connect to it:

```        "tv-local~iris": {
            "webServer": {
                "scheme": "http",
                "host": "127.0.0.1",
                "port": 42773
            },
            "description": "Data Studio in a box on your local PC"
        },
```

You can authenticate with the 'SuperUser' credentials mentioned above.

# Troubleshooting

## Make sure you run docker login

Make sure you authenticate to `irepo.intersystems.com` with:

```bash
docker login irepo.intersystems.com
```

## failed to create network

When you try to start the composition by running `./start.sh` and you see an error like this:

```
failed to create network business-360_default: Error response from daemon: Pool overlaps with other one on this address space
```

Make sure you don't have any containers running on your machine and run the following command:

```bash
docker network prune -f
```

The issue is that another composition is using the same subnet of ours. By bringing down all containers and running `docker system prune` you are removing that docker network that is conflicting with ours. 

Now you can try running `./start.sh` again.

