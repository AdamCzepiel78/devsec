pipeline {
  agent any

  stages {
    stage('Build Artifact') {
        steps {
          sh "mvn clean package -DskipTests=true"
          archiveArtifacts artifacts: 'target/*.jar',
            allowEmptyArchive: false,
            fingerprint: true,
            onlyIfSuccessful: true
        }
      }
    stage('Unit Test'){
        steps {
          sh "mvn test"
        }
        post {
          always {
            junit 'target/surefire-reports/*.xml'
            jacoco execPattern: 'target/jacoco.exec'
          }
        }
    }
    stage('Docker Build and Push'){
      steps {
        withDockerRegistry([credentialsId: 'dockerhub', url: ""]) {
          sh 'printenv'
          sh 'docker build -t aczepiel/number_app:""$GIT_COMMIT"" .'
          sh 'docker push aczepiel/number_app:""$GIT_COMMIT""'
        }
      }
    }
    stage('Kubernetes Deployment - DEV'){
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']){
          sh "sed -i 's#replace#aczepiel/number_app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
          sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }
  }
}
