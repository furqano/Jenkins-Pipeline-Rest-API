node {
    try {
        stage("Prep"){
             cleanWs()   
    }
        stage("Build") {
            git branch: '**', url: 'https://github.com/furqano/Jenkins-Pipeline-Rest-API.git'
            sh '''sudo cp -rvf * /root/restapi   
            if sudo docker ps -a | grep maven
            then
            sudo docker rm -f maven
            sudo docker run -d --rm --name maven -v /root/restapi:/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn package
            else
            sudo docker run -d --rm --name maven -v /root/restapi:/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn package
            fi'''
            
        stage("Dockerbuild")
        {
            sh '''if sudo docker images | grep app
            then
            sudo docker rmi -f app
            sudo docker build -t app /root/restapi/
            else
            sudo docker build -t app /root/restapi/
            fi'''
        }
        stage("Mongo-Deploy")
        {
            sh '''if sudo docker ps -a | grep mongo
            then
            echo "image exists"
            else
            sudo docker run -d -p 27017:27017 --name mongo mongo
            fi'''
        }
        stage("App Deploy"){
            sh '''if sudo docker ps -a | grep app
            then
            sudo docker rm -f app
            sudo docker run -d -p 6035:6035 --name app app
            else
            sudo docker run -d -p 6035:6035 --name app app
            fi'''
        }
        stage("Notify Users"){
            sh'''
            IP=$(sudo docker container inspect -f '{{ .NetworkSettings.IPAddress }}' app )
            '''
            emailext(
        subject: "Job sucess",
        body: " Your Jenkins Pipeline rest api app sucess.",
        recipientProviders: [buildUser()],
        to: 'mohamedfurqan.ocert@gmail.com')
        }
    }
stage("ErrorHandling"){
    echo 'Begining of error handling'
}    
echo 'Job was sucessful'
}catch(e){
    echo ' This will run only if failed'
    throw e
    emailext(
        subject: "Job Failed",
        body: " Your Jenkins Pipeline rest api app failed",
        recipientProviders: [buildUser()],
        to: 'mohamedfurqan.ocert@gmail.com')
}
}
