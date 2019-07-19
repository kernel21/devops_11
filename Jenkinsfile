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
    stage('Run Docker') {
        steps {
             script {
                docker.withRegistry( 'https://' + registry, registryCredential ) {
                docker.image('jenkins-image/build-agent:latest').withRun('--privileged') {
                 git git_repo
                 sh '/etc/init.d/docker start'
                }
            }
            }
        }
        }

}
}