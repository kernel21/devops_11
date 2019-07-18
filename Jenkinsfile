pipeline {
  environment {
    registry = "registry.els24.com/jenkins-image/maven_tomcat"
    registryCredential = 'docker_registry'
    container_name = 'tomcat8'
    prod_docker_host = '10.4.1.152:4243'
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/kernel21/devops_11.git'
      }
    }
    stage('Building image') {
      steps {
        script {
            docker.withRegistry( 'https://' + registry, registryCredential ) {
            dockerImage = docker.build registry + ":$BUILD_NUMBER"
            }
        }
      }
    }
    stage('Deploy Image') {
      steps {
        script {
            docker.withRegistry( 'https://' + registry, registryCredential ) {
            dockerImage.push()
            }
        }
      }
    }
    stage('Registring image') {
        steps {
            script {
            docker.withRegistry( 'https://' + registry, registryCredential ) {
    		dockerImage.push 'latest'
    		}
        }
      }
    }

	stage('Removing local image') {
        steps {
            script {
            sh "docker rmi $registry:$BUILD_NUMBER"
            sh "docker rmi $registry:latest"
        }
      }
    }

    stage ('Deploy to prod docker') {
    steps{
        sh 'docker -H $prod_docker_host container stop -f $container_name &>/dev/null'
        sh 'docker -H $prod_docker_host container rm -f $container_name &>/dev/null && sleep 10'
        sh 'docker -H $prod_docker_host run --name $container_name -d -p 8080:8080 $registry:latest'
      }
    }
}
}