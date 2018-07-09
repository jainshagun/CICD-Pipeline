pipeline {
    agent any

    stages {
        //stage('Build') {
            //steps {
                //echo 'Building..'
		//bat 'mvn clean package docker:build'
            //}
	   // post{
		//always{
                     //withSonarQubeEnv('sonarQube') {
                     // requires SonarQube Scanner for Maven 3.2+
                    // bat 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
                    // }
               // }
	   // }
       // }
    	//stage('Deploy') {
           // steps {
               // echo 'Deploying....'
		//bat 'docker run -d -p 9999:8080 hello'
            //}
    	//}
    	//stage('Fuctional Test') {
            //steps {
               // echo 'Testing..'
		//bat 'sleep 30'
		//dir("$WORKSPACE/hellocucumber") {
			//bat 'mvn test'
		//}
	    //}
       // }
	//stage('Create JIRA') {
	   // steps {
                //echo 'Creting JIRA....'
		//sh "./CICDscript.sh -k 'CICD' -s 'CICD Pipeline' -d 'CICD Pipeline test' -a $WORKSPACE/hellocucumber/target/surefire-reports/*.txt"
           // }
    	//}
	//stage('PT Test') {
	   // steps {
               // echo 'PT Testing....'
		//dir("$WORKSPACE/jmeter-testproject") {
		//	bat 'mvn verify'
		//}
           // }
    	//}
	stage('Add PT result to JIRA') {
	    steps {
                echo 'Creting JIRA....'
		bat 'xcopy /s/Y "%WORKSPACE%\\jmeter-testproject\\target\\jmeter\\results\\*.csv" "%WORKSPACE%"'
		sh 'file=`ls $WORKSPACE/*.csv`;./CICDscript.sh -k "CICD" -s "CICD Pipeline" -d "CICD Pipeline test" -a $file'
	    }
    	}
    }
}
