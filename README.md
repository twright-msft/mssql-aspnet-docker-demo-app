# SQL Server on Linux + ASP.NET Core app demo
This project is a demonstration of how to build ASP.NET Core applications with SQL Server on Linux in Docker containers using Docker Compose.

This is the standard ASP.NET defaul app, but with the twist of using SQL Server in a container that the app connects to.  Docker Compose is used to bring up the app and the SQL Server container together.

# Running this demo
Prerequisites:
* Git
* Docker for Mac, Docker for Windows, or Docker Engine

To run this demo, first create a folder, cd into it, and then git clone the project.
```
git clone https://github.com/twright-msft/mssql-aspnet-docker-demo-app.git
```

Then run these commands to start the containers:
```
cd webapp
docker-compose up
```

Then you can access the web app at http://localhost:8000.

# Details
A few key points about this demo app:
## docker-compose.yml file
Note that there are two images - one for the web app (web) and one for SQL Server (db).  The DB image uses [microsoft/mssql-server-linux](https://hub.docker.com/r/microsoft/mssql-server-linux/) as the base.  It is the SQL Server vNext image for running on Linux.  Whenever you start a mssql-server-linux container, you need to pass in some environment variables:
* ACCEPT_EULA=Y
* SA_PASSWORD=<your strong SA login password>
For this demo the password is set to 'Yukon900' but you can change it if you want.  Make sure you also change it in web container environment configuration if you do though!

The web container also has some environment variables that are passed in when the container is created.  These are then used to build the connection string to connect to the SQL Server.  Note that the server name is 'db'.  This is the name that the SQL Server container is known by the web container as on the container network.  Note the name of the DB is 'mydb'.  You can change this to whatever you want.  Entity Framework will attempt to create the DB if it doesnt already exist.

## entrypoint.sh
The entrypoint.sh script in this demo does something special.  It calls this command to tell Entity Framework to create the database if it doesnt exist already and then to populate the schema for the app into it:
```
dotnet ef database update
```
Note that this command is wrapped in a do/until loop to allow SQL Server time to come up and for the migrations to be run before continuing on and starting the app.

## Startup.cs
This is the startup routine of the app.  The key thing to point out here is how the environment variables are passed in and automatically added to the Configuration string array.  The startup routine reads out the DB server name ('db' - see above), DB name ('mydb' - see above), login, password and then constructs the connection string.

Other than those small changes, this is just the standard default ASP.NET Core web application.  From here, you can customize the app to do whatever you want and have SQL Server as the data store.

Don't forget to make sure you use persistence for your SQL Server container!

If you're not familiar with ASP.NET Core, read on!

# Welcome to ASP.NET Core

We've made some big updates in this release, so it’s **important** that you spend a few minutes to learn what’s new.

You've created a new ASP.NET Core project. [Learn what's new](https://go.microsoft.com/fwlink/?LinkId=518016)

## This application consists of:

*   Sample pages using ASP.NET Core MVC
*   [Bower](https://go.microsoft.com/fwlink/?LinkId=518004) for managing client-side libraries
*   Theming using [Bootstrap](https://go.microsoft.com/fwlink/?LinkID=398939)

## How to

*   [Add a Controller and View](https://go.microsoft.com/fwlink/?LinkID=398600)
*   [Add an appsetting in config and access it in app.](https://go.microsoft.com/fwlink/?LinkID=699562)
*   [Manage User Secrets using Secret Manager.](https://go.microsoft.com/fwlink/?LinkId=699315)
*   [Use logging to log a message.](https://go.microsoft.com/fwlink/?LinkId=699316)
*   [Add packages using NuGet.](https://go.microsoft.com/fwlink/?LinkId=699317)
*   [Add client packages using Bower.](https://go.microsoft.com/fwlink/?LinkId=699318)
*   [Target development, staging or production environment.](https://go.microsoft.com/fwlink/?LinkId=699319)

## Overview

*   [Conceptual overview of what is ASP.NET Core](https://go.microsoft.com/fwlink/?LinkId=518008)
*   [Fundamentals of ASP.NET Core such as Startup and middleware.](https://go.microsoft.com/fwlink/?LinkId=699320)
*   [Working with Data](https://go.microsoft.com/fwlink/?LinkId=398602)
*   [Security](https://go.microsoft.com/fwlink/?LinkId=398603)
*   [Client side development](https://go.microsoft.com/fwlink/?LinkID=699321)
*   [Develop on different platforms](https://go.microsoft.com/fwlink/?LinkID=699322)
*   [Read more on the documentation site](https://go.microsoft.com/fwlink/?LinkID=699323)

## Run & Deploy

*   [Run your app](https://go.microsoft.com/fwlink/?LinkID=517851)
*   [Run tools such as EF migrations and more](https://go.microsoft.com/fwlink/?LinkID=517853)
*   [Publish to Microsoft Azure Web Apps](https://go.microsoft.com/fwlink/?LinkID=398609)

We would love to hear your [feedback](https://go.microsoft.com/fwlink/?LinkId=518015)
