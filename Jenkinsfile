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
    }
    
    stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
    }

    stage('Sonarqube - SAST'){
      steps{
        withSonarQubeEnv('Sonarqube'){
          sh "mvn clean verify sonar:sonar -Dsonar.projectKey=maven-application -Dsonar.projectName='maven-application' -Dsonar.host.url=http://aczjenkins.eastus.cloudapp.azure.com:9000 -Dsonar.token=squ_bda6226eef8cce74b7ced2d676c2dcc80ad57cfa"
        }
        timeout(time: 2, unit: 'MINUTES'){
          script{
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }

    stage('Vulnerability Scan - Docker ') {
      steps {
        sh "mvn dependency-check:check"
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
  post {
    always {
      junit 'target/surefire-reports/*.xml'
      jacoco execPattern: 'target/jacoco.exec'
      pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
      dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
    }
  }
}
