# Jenkins Pipeline Rest API

An CI/CD Jenkins Pipeline to deploy the Rest API application in containerized end-to-end approach.

## Tech Stack

* Jenkins
* Docker
* Git

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
 
## Creating GIT-WebHooks
 
 ```
 repository setting -> webhooks -> add webhook -> paste the <url/github-webhook/>
 ```
 
Once there is a commit in the repo the Job will atomatically trigger.

## job 1 -  To download the code from repo and create jar file using mvn 
```
sudo cp * /root/restapi    #copy the project code from workspace to project folder

if docker ps -a | grep maven
then
sudo docker rm -f maven
else
docker run -it --rm --name maven -v /root/restapi:/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn package
fi
```
### Used Maven Docker image to directly build the project .jar file.

![image](https://user-images.githubusercontent.com/64476159/164054044-b41cf471-3cc8-44ed-a994-1a5a37fbcb55.png)

## job 2 - To create a docker image using dockerfile
```
if sudo docker images | grep app
then
echo "Img already exists"
else
sudo docker build -t app /root/restapi/
fi
```
This Job will create a Dockerfile for the RestApi deployment. Can use pre-built app from Docker Repo 'furqano/restapi-app' image to avoid job-2.
![image](https://user-images.githubusercontent.com/64476159/164054520-e306d295-aa42-4daf-91ad-eba1c706b871.png)
![image](https://user-images.githubusercontent.com/64476159/164054575-6e6c96cd-3150-428f-a34d-af6dd05b5348.png)

## job 3 -  launch mongodb
```
if sudo docker ps -a | grep mongo
then
sudo docker rm -f mongo
else
sudo docker run -d -p 27017:27017 --name mongo mongo
fi
```
![image](https://user-images.githubusercontent.com/64476159/164054741-8364777a-107e-4327-bb63-5155562f2840.png)

## job 4 - launch application
```
if sudo docker ps -a | grep app
then
sudo docker rm -f app
else
sudo docker run -d -p 6035:6035 --name app app
fi
```
![image](https://user-images.githubusercontent.com/64476159/164054857-4025e747-dee7-49a1-9a0d-971a739dfda9.png)

## job 5 - Print the IP address of the Docker Instance 
Used Docker Inspect to get the IP and print can be integrated with emailer to get the detailed pipeline build details.
```
sudo docker container inspect -f '{{ .NetworkSettings.IPAddress }}' app
```
![image](https://user-images.githubusercontent.com/64476159/164055147-884a85ec-1116-424e-9a6f-ac0c301be585.png)


## Screenshots

![image](https://user-images.githubusercontent.com/64476159/164056676-4e38746b-8548-43c1-82d2-8ffedf65e1c6.png)

For detailed usage of rest api app can check out ![rest-api-2-server](https://github.com/furqano/Java-Rest-API-2-Server)
