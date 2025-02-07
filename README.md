# Repo summary
This repo is a collection of GitHub action challenges intended to help developers learn how to use workflows. While hints
are included in some workflows, these are not intended as tutorials, and developers are encouraged to research
independently to find possible solutions.

# How to use
Users should fork the repo into their own account, then clone locally and experiment with each challenge. While each
workflow has set tasks, users are encouraged to experiment beyond those confined, and some suggested stretch goals are included.

In the .github/WorkflowSamples folder are a collection of incomplete workflows of increasing complexity. To use one, move it
into the .github/workflows directory, fill in the needed code, and push to GitHub to test your work. Workflows will NOT run
on GitHub unless they are in that directory. In your GitHub repo, locate the output under the Actions tab to verify and 
troubleshoot work. After completing each workflow, move onto the next numerical workflow, moving previous workflows back 
to the WorkflowSamples directory if desired to keep actions manageable.

## 1.Hello World
An introduction to basic workflow syntax and usage, fill in the needed code to check out code print text on each push to main.

## 2. Dependant Jobs
GitHub actions can be set to require other jobs to successfully finish before running. Create two simple jobs, with the 
job that is defined first not running until the job that is defined second has completed

## 3. External Webhooks
A simple print job, it should respond to an external request, rather than run on an internal GitHub trigger.
Here is a possible curl request that should trigger the actions. When the request is sent, the actions should appear in 
the Actions tab of the repo, and the text should print when the action is inspected. Make sure to replace {owner} and 
{repo} in the url

```
curl -X POST
-H "Accept: application/vnd.github+json"
-H "Authorization: token {your_classic_pat_token}"
-d '{"event_type": "webhook", "client_payload": {"key": "value"} } '
https://api.github.com/repos/{owner}/{repo}/dispatches
```

## 4. Docker Images
A frequent use of any CI/CD pipeline is to create a Docker container of the application and deploy it to the orgs server.
This workflow is split into two parts, and it is recommended to get the first working completely before moving on to the 
second.
### Build and Push the Docker Image
- This step will require an account with DockerHub, or another image repository of your preference
- There is a much higher complexity level for this workflow than previous ones, but docker actions are well documented and a link to those docs are provided
- DockerHub username and Access tokens will need to be saved as GitHub secrets and accessed in the workflow
- Be aware that Docker images will need a JAR file built for Java applications before they can build
- Some build and push actions may require the `context` property on the action
- Be sure to check the Dockerfile if running into problems to ensure that paths and ports are correct for your setup
- After successfully run, the image should appear in your DockerHub repo.
### Deploy Docker Container
Once your image is successfully being built and published, the next step is to deploy it to server
- This step will require a pre-existing ec2 instance on AWS
- Create new ec2 instance, noting public IPv4 address
- Create key pair, downloading .pem file or other access token choice
- The simplest t2.micro instance is sufficient. While these instance are extremely cheap or free, they should be deleted as soon as you are done to prevent any billing
- EC2 host(ip address), user, and ssh key(.pem file or other aws token) should be saved as GitHub secrets and passed to the workflow
- There are many ways to accomplish this, one possible approach is to use the `appleboy/ssh-action` action to SSH into the server, then run appropriate steps to pull and run your image
- Alternatively, research any number of preexisting published actions to deploy containers
### API Endpoints
This application is a simple Todo API, with three endpoints you can test. Once the container is deployed, you should be able to reach these endpoints to test your work.
-  GET `/todos` to see all tasks 
  - Remote curl sample: `curl -X GET "http://{ec2 public IPv4}:8080/todos"`
  - Local curl for testing: `curl -X GET "http://localhost:8080/todos"`
- POST `/todos?task={TaskName}` to create a task
  - Remote curl sample: `curl -X POST "http://{ec2 public IPv4}:8080/todos?task=SampleTask"`
  - Local curl for testing: `curl -X POST "http://localhost:8080/todos?task=SampleTask"`
- DELETE `/todos/{id}/complete`  to set a tasks 'comlete' field to true
  - Remote curl sample: `curl -X DELETE "http://{ec2 public IPv4}:8080/todos/1/complete"`
  - Local curl for testing: `curl -X DELETE "http://localhost:8080/todos/1/complete"`

## 5. Terraform
This workflow is another step in complexity to create and provision a new ec2 instance using terraform and ansible directly from the workflow.
As this is a GitHub actions project, we have made the terraform and ansible files as low maintenance as possible, nonetheless,
you may need to troubleshoot the terraform `main.tf` and ansible `playbook.yml` files to ensure that all paths and credentials are correctly set.
Here is a breakdown of what is needed in those files, as well as some suggestions for extra challenges to improve the infrastructure

 ### Terraform
 - use existing key pair, or create a new key pair in AWS, download .pem file
 - set up aws cli locally with your access key and secret access key set to test deployment locally
 - update `key_name` at under "aws_instance" resource to the name of your key
 - key paths are currently written to point to saved GitHub secrets, to test terraform locally you will need to update paths to your pem file in "remote-exec" connection, and "local-exec" ansible playbook command

CHALLENGE: Terraform is designed to be idempotent, so that it will not run code if that code does not need anything. However, 
GitHub actions run on ephemeral machines that will not save terraform state after each run. As a result, future runs of this file will 
error when trying to create duplicate security groups unless you manually delete the group before running. As an extra 
challenge, add code to the `main.tf` to check for existing security group, or, better to save the `terraform.tfstate` file in a 
s3 bucket and reference it on each run to stay truly idempotent

 ### Ansible
 - update dockerhub username to your username at lines 24 and 27, i.e. `docker pull <username>/<application name>:latest`

CHALLENGE: Safe username in GitHub secrets, pass it to terraform as a variable, then output it in `main.tf` and reference it in the playbook to avoid hardcoding