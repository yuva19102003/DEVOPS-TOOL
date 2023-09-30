AWS COMMAND LINE INTERFACE:

----------------------------------------------------------------------------------------------
installation in windows

    Download and run the AWS CLI MSI installer for Windows (64-bit):

    https://awscli.amazonaws.com/AWSCLIV2.msi

Alternatively, you can run the msiexec command to run the MSI installer.

C:\> msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

For various parameters that can be used with msiexec, see msiexec

on the Microsoft Docs website. For example, you can use the /qn flag for a silent installation.

C:\> msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /qn

To confirm the installation, open the Start menu, search for cmd to open a command prompt window, and at the command prompt use the aws --version command.

C:\> aws --version
aws-cli/2.10.0 Python/3.11.2 Windows/10 exe/AMD64 prompt/off

----------------------------------------------------------------------------------------------

installation in linux

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

-----------------------------------------------------------------------------------------------
Commonly Used Commands in AWS CLI
-------------------------------------------------------------------------------

Some of the most common CLI commands are the following:
Configuration Commands

Create profiles:
----------------
aws configure –profile profilename

Output format:
-------------
aws configure output format

To specify your AWS region:
--------------------------
aws configure region (region-name)
Amazon EC2 Commands
-------------------
Launch an Amazon EC2 instance (must update the AMI ID):

aws ec2 run-instances –instance-type t2.micro –image-id ami-0f5411afa59916e0e –region us-east-1
Amazon API Gateway Commands

List API Gateway IDs and names:
-------------------------------
aws apigateway get-rest-apis | jq -r ‘.items[] | .id+” “+.name’

List API Gateway Keys:
----------------------
aws apigateway get-api-keys | jq -r ‘.items[] | .id+” “+.name’
Amazon CloudFront

List CloudFront distributions and origins:
------------------------------------------
aws cloudfront list-distributions | jq -r ‘.DistributionList.Items[ ] | .DomainName+ “ “+Origins.Items[0].DomainName’
Amazon CloudWatch

List information about an alarm:
--------------------------------
aws cloudwatch describe-alarms | jq -r ‘.MetricAlarms[ ] | .AlarmName+” “+.Namespace+” “+.StateValue’
Amazon DynamoDB

List DynamoDB tables:
---------------------
aws dynamodb list-tables –region ap-southeast-2 // replace with your region

Get all items from a table:
---------------------------
aws dynamodb scan –table-name events // replace with your table name
IAM Group

List groups:
------------
aws iam list-groups | jq -r .Groups[ ].GroupName

Add/Delete groups:
-----------------
aws iam create-group –group-name (groupName)
IAM User

Get single user:
---------------
aws iam get-user –user-name (username)

Add user:
--------
aws iam create-user –user-name (username)

Delete user:
------------
aws iam delete-user –user-name (username) 
-----------------------------------------------------------------------------------------------
