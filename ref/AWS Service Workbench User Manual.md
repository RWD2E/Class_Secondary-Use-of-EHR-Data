# What is Service Workbench (SWB)
[Service workbench](https://docs.aws.amazon.com/solutions/latest/service-workbench-on-aws/overview.html) is a self-service analytical platform that operates on a web-based portal, which provide a collaborative research and data democratization solution to the researchers. Researchers in an organization can access a portal, quickly find data that they are interested in, with a few clicks, analyze data using their favorite analytical tools as well as machine learning service such as the [Amazon SageMaker](https://aws.amazon.com/sagemaker/) notebooks. This platform can also be used to manage and facilitate virtual classrooms.

***************************************

# Account Initialization
Upon approval of account request, an AWS user account will be created for you. A verification email will be sent to the registered email address for account initialization, which includes a) verifying email address, b) setting up password, c) setting up multi-factor authentication (MFA) on your chosen device. Once the initial setup is completed, go to the AWS SWB login portal: 

> [aws.nextgenbmi.umsystem.edu](http://aws.nextgenbmi.umsystem.edu)

you should be able to see the following landing page and log into the service workbench portal with your AWS credentials and MFA. Make sure to bookmark the above url for recurrent visits. 

![landing-page](/ref/img/landing-page.png)

*Note: you will be re-directed to the AWS SSO log-in page to sign into
your service workbench page. If not re-directed, that usually suggests
that your current AWS session hasn’t expired.*

After successfully loggin in, the home page of your AWS SWB space looks like the following with 4 sub-sections found on the sidebar: 
- Dashboard: default home page to show your computational spending over the past 30 days
- SSH Keys: SSH keys generation for linux workspace log-in
- Studies: Navigate to create or access My Study, Organization Study or Open Data study. 
- Workspaces: Navigate to create stand-along workspaces or access existing workspaces

![home-page](/ref/img/home-page.png)


***************************************

# Studies and Workspaces
## What is a Study? 
A **Study** is a mechanism **creating a shared storage space (i.e. s3 bucket)** accessible by multiple workspaces. We recommend to always start with creating a study and associate workspace with studies (if a study was not created by admin and assigned to you). However, you may skip the study creation study to start a stand-alone workspace (note that your data will not be sharable with others without associating with study). There are two types of study: **My Study** and **Organization Study**. 

**My Study** is an individual study which is only visible to the creator. Following the steps show in the figure below to create a My Study.

![my-study](/ref/img/my-study.png)

**Organization Study** could involve multiple approved users to collaborate on a study by accessing a shared storage space. *Note that SWB administrators may have pre-created an Organization Study for you based on your request.* However,you may still create your organizaion study, which may require additional parameters. 

![org-study](/ref/img/org-study.png)

There are three pre-defined roles can be used to manage an organization study: “admin”, “read-write”, and ”read-only”. Please note that only existing and active SWB users can be added from a pre-populated list. If someone you want to add can not be found, please email <ask-umbmi@umsystem.edu> for support. 

![org-study-role](/ref/img/org-study-role.png)

## What is a Workspace? 
A **Workspace** is a **virtual machine** or **computing instance**, where you can deploy a linux, windows or sagemaker instance to use your favorite analytic tool to analyze the data. You can either create a stand-alone workspace, or to associate it with an existing study. Associating workspace with a study will enable the creation of shared and persistent storage space. 

## Launch a Workspace
There are currently three types of workspace that can be launched for any study. For each workspace type, we provisioned multipled types of instances with different configurations of memory and CPU. **You SHOULD ALWAYS deploy a workspace under a study for presistent storage**. An organization study named **Acacemic-MUIRB210020** has been created and all workspaces are expected to be created under it. 

![workspace-launch1](/ref/img/workspace1.png)

![workspace-launch2](/ref/img/workspace2.png)

**Note that the Project ID for our class will be **Acacemic-MUIRB210020**

For each workspace, we provided 9 standard configurations: 
- Large: 2 CPU, 4GB RAM (balanced, CPU optimal, memory optimal)
- XLarge: 2 CPU, 8GB RAM (balanced, CPU optimal, memory optimal)
- 2XLarge: 4 CPU, 16GB RAM (balanced, CPU optimal, memory optimal) 

For basic statistical analysis on small-to-medium sized dataset, using any of the **..XLarge** configuration with **2 CPU** and **8GB memory** should be sufficient. However, you can always switch to bigger workspaces when computational needs escalate. The difference among **(balanced, CPU optimal, memory optimal)** are whether the underlying virtual machine firmware is configured towards optimizing the use of CPU or Memory or keeping a balance.  

************************************************

### Launch a Windows Workspace
Windows workspace are deployed using remote desktop protocol (RDP) under service workbench. If you are using a windows machine, RDP comes with the OS system. If your operating system (OS) is macOS, then you will need to install a RDP client.

#### Workspace Parameters
Once a windows workspace has been successfully provisioned for your study, you will be provided with RDP launching parameters as follows:

![workspace-windows-param](/ref/img/workspace-windows-param.png)

#### Remote Desktop Connection
If you are a windows user, type “RDP” in the search box on taskbar and open a new Remote Desktop Connection session as shown in the figures below:

![workspace-windows-rdp1](/ref/img/workspace-windows-rdp1.png)

![workspace-windows-rdp2](/ref/img/workspace-windows-rdp2.png)

It would take around ~20 minutes for the remote desktop to launch. When you first launch the remote desktop session, it will ask for a network option **“Do you want to allow your PC to be discoverable by other PCs and devices on this network?“** - choose **“Yes”** to make it discoverable, so that you will be able to log back in next time. 

![workspace-windows-discoverable](/ref/img/workspace-windows-discoverable.png)

************************************************

### Whitelist IP Addresses
If you want to work on the same workspace but from different location (thus different IP address), you will need to whitelist your new IP address using the `Edit CIDRs` option:

![add-ip](/ref/img/add-ip.png)

**!!Please follow the best practice and only access your workspace from “Domain networks” (such as a workplace network) or “Private networks” (such as your home or work networks)!!**

************************************************

### Stop a Workspace
Go to `Workspace` page from sidebar and stop the unused workspace to minimize costs. You can always re-start the workspace, which only takes less than 1 minute.

![stop-workspace](/ref/img/stop-workspace.png)

### Terminate a Workspace
Go to `Workspace` page from sidebar and terminate the workspace that you will never use or want to destroy. **Please note that the terminated workspace cannot be recovered, except for data saved on D: (data) drive when workspace was created with association to a study.**

![terminate-workspace](/ref/img/terminate-workspace.png)


***************************************

## Use of Other Types of Workspaces
Go to the [full AWS SWB User Manual](https://github.com/gpcnetwork/grouse-cms/wiki/Service-Workbench-User-Manual) for additional informations on use of other Types of workspaces (Sagemaker Jupyter Notebook/Python workspace, Linux workspace). 


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

![odbc-app](/ref/img/odbc-app.png)

## Step 2: Configure ODBC Driver
To configure the ODBC driver in a Windows environment, follow the next steps described in [this post](https://docs.snowflake.com/en/user-guide/odbc-windows.html#step-2-configure-the-odbc-driver) to create the ODBC DSN and test if the ODBC DSN is working fine with the following parameters:

```
1.  Data Source: snowflake_deid
2.  User: <your pawprint>@umsystem.edu
3.  Password: leave it blank, as you will need to specify it later when calling this ODBC connector
4.  Server:mf63245.us-east-2.aws.snowflakecomputing.com
5.  Database: [snowflake database you want to connect to] CLASS_MEMBER_<your pawprint>_DB
6.  Schema: [snowflake schema you want to connect to] PUBLIC
7.  Warehouse: [snowflake warehouse you want to use] NEXTGENBMI_WH
8.  Role: [snowflake role you are pre-assigned to] CLASS_MEMBER_<your pawprint>
9.  Tracing: 6
10. Authenticator: externalbrowser
```
Note: once your snowflake has been activated, the `[snowflake_account_name]` can be found from the url link to snowflake log-in page. `Database` and `Schema` are optional. You may have visibility to all other databases and schema once the connection is established. However, you may not be able to query all databases depending on your role privilege on the Snowflake side.

## Step 3: Connect to Snowflake with ODBC driver
You will need to install the `DBI` and `odbc` packages before making the database. You can then make the database connection call by implicitly calling for the credentials saved in the environment:

```
# make database connection
myconn <- DBI::dbConnect(
    drv = odbc::odbc(),
    dsn = 'snowflake_deid',
    uid = '<your pawprint>@umsystem.edu',
    pwd = ''
)
```
This will trigger a web browser to open the MU log-in portal, which should be similar as the log-in process directly from snowflake interface. 



***************************************************************

# References
- [MU AWS Service Workbench User Manual](https://github.com/gpcnetwork/grouse-cms/wiki/Service-Workbench-User-Manual)
- [AWS service workbench User Guide](https://github.com/awslabs/service-workbench-on-aws/blob/mainline/docs/Service_Workbench_Post_Deployment_Guide.pdf): this is the service workbench user guide provided by AWS