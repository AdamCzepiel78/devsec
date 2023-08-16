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
          sh 'printenv'
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            sh 'docker build -t adamczepiel/number_app:""$GIT_COMMIT"" .'
            sh 'docker push adamczepiel/number_app:""$GIT_COMMIT""'
          }
        }
      }
    }
}
