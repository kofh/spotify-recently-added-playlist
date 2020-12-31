# Spotify Recently Added Playlist

* [Overview](#overview)
* [Prerequisites](#prerequisites)
* [Setup](#setup)

## Overview

This repository includes the terraform and application code necessary to deploy a lambda function to AWS which will periodically update a playlist of recently added songs in your spotify library.

## Prerequisites

* An AWS Account
* A Spotify Premium Account

## Setup

### Terraform

[Terraform](https://www.terraform.io) is my preferred way of defining [infrastructure as code](https://www.hashicorp.com/resources/what-is-infrastructure-as-code). Their [Terraform Cloud](https://www.terraform.io/cloud) product has a free tier and maintains the terraform state file for you.

#### Setting Up the Workspace

1. Log into the Terraform Cloud UI. From the top menu, create a new organization (or use an existing one).
2. Once you're inside your organization, click the `+ New Workspace` button in the top right of the screen
3. Go through the Create Workspace wizard:
   1. For Workflow, choose Version Control Workflow
   2. Choose Github (or connect your github)
   3. Select the name of your repository (`[yourname]/spotify-recently-added-playlist`)
   4. Name the workspace whatever you'd like

#### Setting up the Terraform IAM User

Since this application will run in AWS, we'll need an AWS IAM User for Terraform Cloud to use. This user will need a dangerous amount of permission over your AWS account in order to successfully manage your infrastructure. Be sure to rotate its credentials often, or make its credentials inactive whenever you're not deploying new/updated infrastructure.

1. Sign into the AWS console
2. Go to the IAM service
3. In the left sidebar, click on Users
4. Click "Add User", and create a new user:
   1. Name the user `Terraform` (or whatever you'd like) and give it Programmatic Access
   2. Click "Next: Permissions"
   3. Click the "Attach existing policies directly" tab, and check the box for `AdministratorAccess` (this should be the first row).
   4. Click "Next: Tags" and add any tags you wish to add
   5. Click "Next: Review", review, and then click "Create User"
   6. You should now see a success message, with the new user's credentials below it. Copy both the Access Key ID and the Secret Access Key (or click "Download .csv")
5. Take a sip of water, AWS can be stressful.
6. Head back to the Terraform Cloud UI, and make sure you're in the workspace created earlier
7. Click the Variables tab, and scroll down the Environment Variables
8. Create `AWS_ACCESS_KEY_ID` and set it to the IAM User's Access Key ID. Make this variable sensitive.
9. Create `AWS_SECRET_ACCESS_KEY` and set it to the IAM User's Secret Access Key. Make this variable sensitive.

#### Deploying our Infrastructure

Terraform Cloud automatically runs everytime you push a commit to your repository. If there haven't been any commits, you can manually trigger a plan through the UI.

1. In your workspace, click the "Queue Plan" button, enter a reason if you want, and then click "Queue Plan" again
2. Wait for the Plan step to finish, and scroll to the bottom of the page.
3. Confirm the plan

If something goes wrong here, the issue is likely with the authentication piece. Double check the steps for Setting up the Terraform IAM User.

If everything looks good, then we've successfully deployed all of the infrastructure we'll need to run the app, as well as the IAM permissions that GitHub Actions will use (discussed in the next section)

### GitHub Actions

GitHub Actions handles moving our code from GitHub to AWS. As this is a common use case (move code from GitHub to AWS) I've set this bit up in a way that grows nicely with the number of projects using this pattern. It goes like this:

* In my account, I have a `GitHub Actions` user with a policy directly attached like this:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ],
            "Resource": "arn:aws:iam::000000000000:role/ga-*",
            "Effect": "Allow"
        }
    ]
}
```
* For each project, I create a role `ga-[name of project]`. That role trusts the `GitHub Actions` user (and can therefore be assumed by it), and the User only has permissions to assume roles that start with the string `ga-`. The advantage here, is in allowing the terraform for each project to create a "deploy policy" on its own, without having to create a new user (and thus manage a password in code).

AWS ships a [Configure AWS Credentials Action](https://github.com/marketplace/actions/configure-aws-credentials-action-for-github-actions) for GitHub Actions. All subsequent steps within a workflow will have access to the AWS CLI. The home page of that action includes more information on how to set up the User/Role relationship I'm using here. For the action to work, we need to define a couple of repository secrets. Namely, for our usage of this action:
* `AWS_ACCESS_KEY_ID`: The Access Key ID of the GitHub Actions User
* `AWS_SECRET_ACCESS_KEY`: The Secret Access key of the GitHub Actions User
* `AWS_ROLE_TO_ASSUME`: The name of the role to assume. The terraform defines this as `ga-sra-upload-lambda-source`, and can be updated by changing the `github_actions_upload_lambda_source_role_name` variable.
