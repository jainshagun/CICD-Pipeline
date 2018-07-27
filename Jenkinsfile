pipeline {
    agent {
        node {
            label 'master'
        }
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
		        sh 'mvn clean package'
            }
	        post{
		        always{
                     withSonarQubeEnv('sonarQube') {
                     sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
                     }
                }
	        }
        }
        stage('Build Image....') {
            steps {
                echo 'Building Image....'
		        sh 'mvn docker:build'
            }
    	}
        stage('Push Image') {
            steps {
                echo 'Pushing Image....'
		        sh 'docker tag hello docker.deveng.systems/devops/hello:v2'
		        sh 'docker push docker.deveng.systems/devops/hello:v2'
            }
    	}
        stage('Deploy') {
            steps {
                echo 'Deploying....'
		        sh 'curl -X PUT -d @cicd.hello-world.json -H "Content-type: application/json" http://deploy.service.eu-west-1.dev.deveng.systems/v2/apps/devops/cicd-hello'
            }
    	}
    	stage('Fuctional Test') {
            steps {
                echo 'Testing..'
		        sh 'sleep 30'
		        dir("$WORKSPACE/hellocucumber") {
			        sh 'mvn test'
		      }
	        }
	        post{
		        always{
		            echo 'Creting JIRA....'
		            sh 'chmod +x Jirascript.sh'
			bat 'xcopy /s/Y "%WORKSPACE%\\hellocucumber\\target\\*.json" "%WORKSPACE%"'
                    withCredentials([usernameColonPassword(credentialsId: 'jira', variable: 'USERPASS')]) {
                    sh 'file=`ls *.json`;./Jirascript.sh --key "CICD" --summary "CICD Test" --description "This is a Test" --outageRequired "Yes" --outageDetails "CICD Test" --startPlan "27/Jul/18 10:00 AM" --startWindow "2018-07-27T10:00:00.0+0000" --endWindow "2018-07-27T13:00:00.0+0000" --contactDelatils "shagun.jain" --impact "No" --changeType "Normal" --outageStart "2018-07-27T10:00:00.0+0000" --outageEnd "2018-07-27T10:30:00.0+0000" --cred "$USERPASS" --attachment "$file"'
                     }
                }
	        }
        }
	    stage('PT Test') {
	        steps {
                echo 'PT Testing....'
		        dir("$WORKSPACE/jmeter-testproject") {
			        sh 'mvn verify'
		        }
            }
            post{
		        always{
		            echo 'Creting JIRA....'
		            sh 'chmod +x Jirascript.sh'
			bat 'xcopy /s/Y "%WORKSPACE%\\jmeter-testproject\\target\\jmeter\\results\\*.csv" "%WORKSPACE%"'
                    withCredentials([usernameColonPassword(credentialsId: 'jira', variable: 'USERPASS')]) {
                    sh 'file=`ls *.csv`;./Jirascript.sh --key "CICD" --summary "CICD Test" --description "This is a Test" --outageRequired "Yes" --outageDetails "CICD Test" --startPlan "27/Jul/18 10:00 AM" --startWindow "2018-07-27T10:00:00.0+0000" --endWindow "2018-07-27T13:00:00.0+0000" --contactDelatils "shagun.jain" --impact "No" --changeType "Normal" --outageStart "2018-07-27T10:00:00.0+0000" --outageEnd "2018-07-27T10:30:00.0+0000" --cred "$USERPASS" --attachment "$file"'
                     }
                }
	        }
    	}
    }
}
