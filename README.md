# Jenkins Pipeline Rest API

An CI/CD Jenkins Pipeline to deploy the Rest API application in containerized end-to-end approach.

## Tech Stack

* Jenkins
* Docker

## Triggering Jenkins Jobs using Git Hooks.

This approach will automatically deploy the application when there is a github code commit.


### CREATING GIT HOOKS POST-COMMIT  
 
 ```
$ notepad .git/hooks/post-commit
``` 

* Paste the below script in the notepad

```
#! bin/bash

git push
```
Note : The .git/hooks/post-commit is global for the working repository no need of creating it for every branch . 
 
# CREATING THE GIT-WEBHOOKS
 
 ```
 repository setting -> webhooks -> add webhook -> paste the <url/github-webhook/>
 ```
## job 1 -  To download the code from repo and create jar file using mvn 
```
sudo cp * /root/restapi    #copy the project code from workspace to project folder

sudo mvn package                # to build the target .jar file

sudo cp Dockerfile /target/     # Copying Dockerfile to build and copy .jar file directly

```

## job 2 - To create a docker image using dockerfile
```
if sudo docker images | grep app
then
echo "Img already exists"
else
sudo docker build -t app /root/restapi/target/
fi
```
## job 3 -  launch mongodb
```
if sudo docker ps -a | grep mongo
then
sudo docker rm -f mongo
else
sudo docker run -d --name mongo mongo
fi
```
## job 4 - launch application
```
if sudo docker ps -a | grep app
then
sudo docker rm -f app
else
sudo docker run -d --name app app
fi
```
## job 5 - Print the IP address of the Docker Instance
```
docker inspect -- 
```

## Screenshots
