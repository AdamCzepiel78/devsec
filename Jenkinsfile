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
    }
}
