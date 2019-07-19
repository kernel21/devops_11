pipeline {
  environment {
    registry = "registry.els24.com/jenkins-image/maven_tomcat"
    registry_build = "registry.els24.com/jenkins-image/build-agent:46"
    registryCredential = 'docker_registry'
    container_name = 'tomcat8'
    prod_docker_host = 'devops8-3.corp.group:4243'
    git_repo= 'https://github.com/kernel21/devops_11.git'
  }
  agent any
  stages {
    stage('Run Docker') {
      agent {
                docker {
                image registry_build
                args '--privileged'}

            }
            steps {
                sh 'uname -a'
                git git_repo
                sh '/etc/init.d/docker start'
        }
        }

}
}