pipeline {
  agent any  
  triggers {
    GenericTrigger(
     genericVariables: [
     [
      key: 'jiranumber',
      value: '$.issue.key',
      expressionType: 'JSONPath', //Optional, defaults to JSONPath
      regexpFilter: '', //Optional, defaults to empty string
      defaultValue: 'cant find value for jiranumber' //Optional, defaults to empty string
     ],
	 [
      key: 'status',
      value: '$.changelog.items[0].toString',
      expressionType: 'JSONPath', //Optional, defaults to JSONPath
      regexpFilter: '', //Optional, defaults to empty string
      defaultValue: 'cant find value for status' //Optional, defaults to empty string
     ]
     ],
     causeString: 'Triggered on $status',
     regexpFilterText: '$status $labels',
     regexpFilterExpression: 'Ready for Release CICD',
     printContributedVariables: false,
     printPostContent: false
    )
  }
  stages {
        stage('Deploy PROD') {
            steps {
                echo 'Deploying....'
		        sh 'curl -X PUT -d @cicd.hello-world.json -H "Content-type: application/json" http://deploy.service.eu-west-1.staging.deveng.systems/v2/apps/devops/cicd-hello'
            }
	    post{
		        always{
				withCredentials([usernameColonPassword(credentialsId: 'jira', variable: 'USERPASS')]) {
		            		sh './Jirascript.sh --rcvnumber $jiranumber --cred $USERPASS'
				}
                	}
	    }
    	}
  }
}
