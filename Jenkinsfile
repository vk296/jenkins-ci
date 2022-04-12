pipeline {
  agent any
  tools {
  maven 'maven'
  }
    stages {

  stage ('Checkout SCM'){
        steps {
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: ' https://vk516@bitbucket.org/vk516/dpt4-jenkins-ci.git']]])
      }
   }
	  
	stage ('Build')  {
	    steps {
        dir('app'){
            sh "mvn package"
          }
        }    
   }
   
  stage ('SonarQube Analysis') {
    steps {
      withSonarQubeEnv('sonar') {           
				dir('app'){
                sh 'mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=vk123-pipeline'
        }
    }
    }
 }

    stage ('Artifactory configuration') {
            steps {
                rtServer (
                    id: "jfrog",
                    url: "https://vijayk.jfrog.io/artifactory",
                    credentialsId: "jfrog"
                )

                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "jfrog",
                    releaseRepo: "vk03-libs-release-local",
                    snapshotRepo: "vk03-libs-snapshot-local"
                )

                rtMavenResolver (
                    id: "MAVEN_RESOLVER",
                    serverId: "jfrog",
                    releaseRepo: "default-maven-virtual",
                    snapshotRepo: "default-maven-virtual"
                )
            }
    }

    stage ('Deploy Artifacts') {
            steps {
                rtMavenRun (
                    tool: "maven", // Tool name from Jenkins configuration
                    pom: 'app/pom.xml',
                    goals: 'clean install',
                    deployerId: "MAVEN_DEPLOYER",
                    resolverId: "MAVEN_RESOLVER"
                )
         }
    }

stage('Docker Build') {
      steps {
        script {
              docker.withRegistry( 'https://registry.hub.docker.com', 'docker' ) {
              def customImage = docker.build("vkdocker516/webapp")
              customImage.push()
          }
      }
    }
}
   stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "jfrog"
             )
        }
    }

  stage('Build Helm Charts') {
    steps {
        dir('charts') {
        withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'username', passwordVariable: 'password')]) {
             sh 'sudo /usr/local/bin/helm package webapp'
             sh 'sudo /usr/local/bin/helm push-artifactory webapp-1.0.tgz https://vijayk.jfrog.io/artifactory/dpt4-helm-local --username $username --password $password'
		  }
        }
        }
      }

  } 
}