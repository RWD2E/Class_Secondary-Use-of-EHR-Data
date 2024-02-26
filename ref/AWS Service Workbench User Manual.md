# What is Service Workbench (SWB)
[Service workbench](https://docs.aws.amazon.com/solutions/latest/service-workbench-on-aws/overview.html) is a self-service analytical platform that operates on a web-based portal, which provide a collaborative research and data democratization solution to the researchers. Researchers in an organization can access a portal, quickly find data that they are interested in, with a few clicks, analyze data using their favorite analytical tools as well as machine learning service such as the [Amazon SageMaker](https://aws.amazon.com/sagemaker/) notebooks. This platform can also be used to manage and facilitate virtual classrooms.

***************************************

# Account Initialization
Upon approval of account request, an AWS user account will be created for you. A verification email will be sent to the registered email address for account initialization, which includes a) verifying email address, b) setting up password, c) setting up multi-factor authentication (MFA) on your chosen device. Once the initial setup is completed, go to the AWS SWB login portal: 

> [aws.nextgenbmi.umsystem.edu](http://aws.nextgenbmi.umsystem.edu)

you should be able to see the following landing page and log into the service workbench portal with your AWS credentials and MFA. Make sure to bookmark the above url for recurrent visits. 

![landing-page](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/landing-page.png)

*Note: you will be re-directed to the AWS SSO log-in page to sign into
your service workbench page. If not re-directed, that usually suggests
that your current AWS session hasn’t expired.*

After successfully loggin in, the home page of your AWS SWB space looks like the following with 4 sub-sections found on the sidebar: 
- Dashboard: default home page to show your computational spending over the past 30 days
- SSH Keys: SSH keys generation for linux workspace log-in
- Studies: Navigate to create or access My Study, Organization Study or Open Data study. 
- Workspaces: Navigate to create stand-along workspaces or access existing workspaces

![home-page](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/landing-page.png)


***************************************

# Studies and Workspaces
## What is a Study? 
A **Study** is a mechanism **creating a shared storage space (i.e. s3 bucket)** accessible by multiple workspaces. We recommend to always start with creating a study and associate workspace with studies (if a study was not created by admin and assigned to you). However, you may skip the study creation study to start a stand-alone workspace (note that your data will not be sharable with others without associating with study). There are two types of study: **My Study** and **Organization Study**. 

**My Study** is an individual study which is only visible to the creator. Following the steps show in the figure below to create a My Study.

![my-study](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/my-study.png)

**Organization Study** could involve multiple approved users to collaborate on a study by accessing a shared storage space. *Note that SWB administrators may have pre-created an Organization Study for you based on your request.* However,you may still create your organizaion study, which may require additional parameters. 

![org-study](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/org-study.png)

There are three pre-defined roles can be used to manage an organization study: “admin”, “read-write”, and ”read-only”. Please note that only existing and active SWB users can be added from a pre-populated list. If someone you want to add can not be found, please email <ask-umbmi@umsystem.edu> for support. 

![org-study-role](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/org-study-role.png)

## What is a Workspace? 
A **Workspace** is a **virtual machine** or **computing instance**, where you can deploy a linux, windows or sagemaker instance to use your favorite analytic tool to analyze the data. You can either create a stand-alone workspace, or to associate it with an existing study. Associating workspace with a study will enable the creation of shared and persistent storage space. 

### Launch a Workspace
There are currently three types of workspace that can be launched for
any study. For each workspace type, we provisioned multipled types of
instances with different levels of memory and computational power. It is always highly recommended to deploy a workspace under a study for presistent storage: 

![workspace1](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/workspace1.png)

![workspace2](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/workspace2.png)

************************************************

### Launch a Linux Workspace
#### Linux CLI
Please refer to the following AWS documents for full instructions on launching Linux instance via SSH with the baseline command line (CLI) interface from:

#### Linux GUI - MobaXterm
Assumptions: these instructions assume you have not created a key pair yet. 
1. **Download and Install MobaXterm** - University of Missouri users should use this link to [download](https://mailmissouri.sharepoint.com/:f:/s/ResearchSupportSolutionsCommunity-Ogrp/EnoQS69VRQVPnk-VqkwHH4gBUyJ7-4O85Hjgx1FO__SJjw?xsdata=MDN8MDF8fGY1MGUzYWY0M2IwODRjMjliYTE1OGMyMzEyOTY4OWRifGUzZmVmZGJlZjdlOTQwMWJhNTFhMzU1ZTAxYjA1YTg5fDF8MHwzMTU1Mzc4OTc1OTk5OTk5OTk5fEdvb2R8VkdWaGJYTlRaV04xY21sMGVWTmxjblpwWTJWOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lJaXdpUVU0aU9pSWlMQ0pYVkNJNk1USjk%3D&sdata=ckE3RytrMWdIV1prTUdHYkNZOEhkaktQVG9Jb1RqZDIvaysrNkVNa2t3ND0%3D&ovuser=e3fefdbe-f7e9-401b-a51a-355e01b05a89%2Ckeelerm%40umsystem.edu) the
educational licensed MobaXterm installer. Other users can use the [private version](https://mobaxterm.mobatek.net/download.html)

When downloading from the SharePoint link, download both files individually by right clicking on the files and selecting download on both.

![mobaxterm](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/mobaxterm.png)

Make sure both files are fully downloading and **are in the same location** then double click on the `.msi` to start the installation wizard. Use the default settings for the installation.

![mobaxterm-install](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/mobaxterm-install.png)

2. **Configure MobaXterm User Environment** - Once complete, launch MobaXterm to have it set up your user environment, and click “Start Local Terminal.” 

![mobaxterm-start-terminal](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/mobaxterm-start-terminal.png)

Enter the following bash commands to create your ssh key folder for use with these instructions:

```shell
mkdir .ssh
chmod 700 .ssh
```

3. **Connect to SWB Linux workspace** - Confirm where `<path-to-home>.ssh` used by MobaXterm. The path is likely to be similar to the following:

`C:\Users\(Your Username)\(OneDrive-University of Missouri)\Documents\MobaXterm\home\.ssh`

But if you are uncertain, you may also navigate to `MobaXterm -> Settings -> General -> Persistent home directory` to confirm the path to the MobaXterm default home directory:

![mobaxterm-dir](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/mobaxterm-dir.png)

**Go to Service Workbench (SWB)**, navigate to the Linux workspace you launched, and click the `Connections` button. Then click `Create Key` as indicated, and follow the prompts. `Download` your `private key`, and if prompted for a location, navigate and save to the `<path-to-home>.ssh` folder, to make it accessible by MobaXterm. If not prompted, open your Downloads folder on your local PC, and cut and paste the `<keyname>.pem` file you downloaded into the `<path-to-home>.ssh` folder. If you copy it anywhere else, make sure to only store this `private key` file in a location you know to be secure, preferably encrypted!

![swb-linux-connect](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/swb-linux-connect.png)

**Return to SWB** and click `Done` in the download prompt, then click `Use This SSH Key` next to the key you just created. Retrieve `public-host` information by clicking the `Copy` icon to the right of the first Host (public) line in the directions that appear, for later use in these instructions. Note that you only have 60 seconds to complete make the connection:

![swb-linux-ssh](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/swb-linux-ssh.png)

**Return to your MobaXterm local terminal**, and first enter the following command to fully secure and enable use of your private key from within MobaXterm:

```shell
chmod 600 .ssh/*
```

**Now you are ready to connect!** Make sure the workspace connection timer hasn’t expired in Service Workbench, and renew it if so, then just enter the following command in the MobaXterm local terminal pasting the Host you copied from above where indicated:

```shell
ssh -CY -i "[path-to-ssh-key].pem" ec2-user@[public-host]
```

Note that the `[path-to-ssh-key]` is by default at `/home/mobaxterm/.ssh/(keyname)`, but can be different if you have the ssh key saved in a different directory. This will securely connect you to your AWS Linux workspace over an SSH tunnel with X11 Forwarding configured, so any graphical applications you run will display in your local MobaXterm environment.

************************************************

### Launch a Windows Workspace
Windows workspace are deployed using remote desktop protocol (RDP) under service workbench. If you are using a windows machine, RDP comes with the OS system. If your operating system (OS) is macOS, then you will need to install a RDP client.

#### Workspace Parameters
Once a windows workspace has been successfully provisioned for your study, you will be provided with RDP launching parameters as follows:

![workspace-windows-param](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/workspace-windows-param.png)

#### Remote Desktop Connection
If you are a windows user, type “RDP” in the search box on taskbar and open a new Remote Desktop Connection session as shown in the figures below:

![workspace-windows-rdp1](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/workspace-windows-rdp1.png)

![workspace-windows-rdp2](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/workspace-windows-rdp2.png)

It would take around ~20 minutes for the remote desktop to launch. When you first launch the remote desktop session, it will ask for a network option **“Do you want to allow your PC to be discoverable by other PCs and devices on this network?“** - choose **“Yes”** to make it discoverable, so that you will be able to log back in next time. 

![workspace-windows-discoverable](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/workspace-windows-discoverable.png)

************************************************

### Launch a SageMaker Notebook


************************************************

### Whitelist IP Addresses
If you want to work on the same workspace but from different location (thus different IP address), you will need to whitelist your new IP address using the `Edit CIDRs` option:

![add-ip](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/add-ip.png)

**!!Please follow the best practice and only access your workspace from “Domain networks” (such as a workplace network) or “Private networks” (such as your home or work networks)!!**

### Stop a Workspace
Go to `Workspace` page from sidebar and stop the unused workspace to minimize costs. You can always re-start the workspace, which only takes less than 1 minute.

![stop-workspace](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/stop-workspace.png)

### Terminate a Workspace
Go to `Workspace` page from sidebar and terminate the workspace that you will never use or want to destroy. **Please note that the terminated workspace cannot be recovered, except for data saved on D: (data) drive when workspace was created with association to a study.**

![terminate-workspace](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/terminate-workspace.png)

************************************************
## Standard Operating Procedure (SOP)

-   No cell (e.g. admittances, discharges, patients, services) 10 or less may be displayed outside of the provisioned AWS computing environment. Also, no use of percentages or other mathematical formulas may be used if they result in the display of a cell 10 or less.

-   Researchers should not download, copy and paste, or transmit any raw data (i.e. patient-level or encounter-level identifiers in conjunction with medical records) off of the provisioned AWS computing environment. Patient-level or encounter-level identifiers includes: patient number, encounter number, a combination of any characteristics that could uniquely identify the individual subject.

- Researchers should not install any unvetted applications without seeking an approval from the system administrators. Any system vulnerability of high risk caused by such installation will result in account dispension immediately.  

-   Researchers should not post any sensitive infrastructural information (e.g. server names, credentials) to external newsgroups, social media, other types of third-party individuals, websites applications, public forums without authority.

-   Always stop instance when not using it for cost optimization. Sagemaker instances have an auto-shutdown capability, but not the other workspace types (i.e., Linux and Windows). An auto-stop features has been developed to stop the workspace is CPU usage is below 5% for 1 hour. 

-   Avoid accessing workspace from “Public networks” such as those in airports and coffee shops, because these networks often have little or no security.

***************************************************

# Use R/Rstuio on Windows Workspace

## Set up ODBC Connector on Windows Workspace
## Step 1: Validate ODBC Driver Installation
An ODBC driver have been pre-installed in your windows system. Click “start” button and type “ODBC”, you should be able to see two "ODBC Data Share Administrator" applications as shown below. Please make sure to select the **"64-bit" version** (the 32-bit version doesn't support snowflake driver). 

![odbc-app](https://github.com/Missouri-BMI/GROUSE/blob/wiki/res/wiki-img/odbc-app.png)

## Step 2: Configure ODBC Driver
To configure the ODBC driver in a Windows environment, follow the next steps described in [this post](https://docs.snowflake.com/en/user-guide/odbc-windows.html#step-2-configure-the-odbc-driver) to create the ODBC DSN and test if the ODBC DSN is working fine with the following parameters:

```
1.  Data Source: snowflake_deid
2.  User: [your snowflake username]
3.  Password: leave it blank, as you will need to specify it later when calling this ODBC connector
4.  Server:[snowflake_account_name].us-east-2.aws.snowflakecomputing.com
5.  Database: [snowflake database you want to connect to] e.g., NEXTGEN_MUIRB######, DEIDENTIFIED_PCORNET_CDM
6.  Schema: [snowflake schema you want to connect to] e.g., CDM_2022_MAY
7.  Warehouse: [snowflake warehouse you want to use] e.g., NEXTGEN_WH, ANALYTICS_WH
8.  Role: [snowflake role you are pre-assigned to] e.g.,NEXTGEN_MUIRB######, ANALYTICS
9.  Tracing: 6
10. Authenticator:
```
Note: once your snowflake has been activated, the `[snowflake_account_name]` can be found from the url link to snowflake log-in page. `Database` and `Schema` are optional. You may have visibility to all other databases and schema once the connection is established. However, you may not be able to query all databases depending on your role privilege on the Snowflake side.

## Step 2a: Configure ODBC Driver with UMSystem Shibboleth
If using "UMSystem Shibboleth" method to log-in, the following additional configuration will be needed: 
a. Your `User` will be your university email address (e.g. xxxx@umsystem.edu). 
b. The `Authenticator` parameter needs to set to `externalbrowser`

## Connect to Snowflake with ODBC driver
### Step 1: Save Credentials as Environment Variable
As security best practice, you never want to have any of your credentials inline your codes. To save your credentials as environment variable in R, navigate to `C:\Program Files\R\R-4.1.2\etc`, open file `Rprofile.site` in any text editor or in R and add your credential information with proper comments such as:

```
# add snowflake log-in credentials as environment variables
Sys.setenv(ODBC_DSN_NAME = 'XXXXX', # the same as the value in the Data Source field from ODBC driver setup
           SNOWFLAKE_USER = 'XXXXXXX', # the same as the value in the User field from ODBC driver setup
           SNOWFLAKE_PWD = 'XXXXXXX' # leave it as empty string (''), when with UMSystem Shibboleth option 
           )
```
After saving the file, restart R (`.rs.restartR()`), and run `Sys.getenv()` to make sure that the environment variables are successfully loaded. 

### Step 2: Make database connection call
You will need to install the `DBI` and `odbc` packages before making the database. You can then make the database connection call by implicitly calling for the credentials saved in the environment:

```
# make database connection
myconn <- DBI::dbConnect(drv = odbc::odbc(),
                         dsn = Sys.getenv("ODBC_DSN_NAME"),
                         uid = Sys.getenv("SNOWFLAKE_USER"),
                         pwd = Sys.getenv("SNOWFLAKE_PWD"))
```

***************************************************************

# Use SAS on Windows Workspace

## Connect to Snowflake with SAS/ACCESS on Windows


***************************************************************

# Use R on Linux Workspace

## Connect to Snowflake with JDBC driver

***************************************************************

# Use Sagemaker Jupyter Notebook

## Connect to Snowflake with Pyhon Connector 


***************************************************************

# References
- [PCORnet Common Data Model site](https://pcornet.org/data-driven-common-model/): includes full details about PCORnet CDM schema
- [AWS service workbench User Guide](https://github.com/awslabs/service-workbench-on-aws/blob/mainline/docs/Service_Workbench_Post_Deployment_Guide.pdf): this is the service workbench user guide provided by AWS