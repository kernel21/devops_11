pipeline {
  environment {
    registry = "registry.els24.com/jenkins-image/maven_tomcat"
    registry_build = "registry.els24.com/jenkins-image/build-agent:latest"
    registryCredential = 'docker_registry'
    container_name = 'tomcat8'
    prod_docker_host = 'devops8-3.corp.group:4243'
    git_repo= 'https://github.com/kernel21/devops_11.git'
  }
  agent any
  stages {
    stage ('Create working directory') {
        steps{
            sh 'mkdir /tmp/docker_builds/ &>/dev/null'
      }
    }

    stage('Build artifacts in docker container') {
          agent {
                docker {
                image registry_build
                // run docker image in privileged mode
                args '--privileged -v /tmp/docker_builds/:/var/lib/docker'}
                }
          steps {
             script {
                docker.withRegistry( 'https://' + registry, registryCredential ) {
                // clone git repo
                git git_repo
                // start docker daemon
                sh '/etc/init.d/docker start'
                // some time for docker ready
                sh 'sleep 10'
                // Building image
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
                // Deploy tagget image
                dockerImage.push()
                // Registring image
                dockerImage.push 'latest'
                // Removing local image
                sh "docker rmi $registry:$BUILD_NUMBER"
                sh "docker rmi $registry:latest"
                }
              }
           }
         }

    stage ('Deploy to prod docker') {
        steps{
            sh 'docker -H $prod_docker_host container stop $container_name &>/dev/null'
            sh 'docker -H $prod_docker_host container rm -f $container_name &>/dev/null && sleep 10'
            sh 'docker -H $prod_docker_host run --name $container_name -d -p 8080:8080 $registry:latest'
      }
    }
 }
}
