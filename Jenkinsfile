pipeline {
    agent any

    stages {
        
    	stage('Deploy') {
            steps {
                echo 'Deploying....'
		bat 'docker run -d -p 9991:8080 hello'
            }
    	}
    	
    }
}