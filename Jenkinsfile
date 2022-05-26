def feedback(status,smsg,fmsg) {

    echo "Feddback Status is: ${status}"
    script {
        switch (status) {
            case 'SUCCESS': 
                mattermostSend (
                    color: "good",
                    channel: 'Sunfire-CICD-Pacman',
                    endpoint: 'http://10.18.99.155:8065/hooks/dr1fon6aqtfydbe1srk4t7ujec',
                    message: "${smsg}"
                )  
                break;
		}
/*            case 'FAILURE':
                mattermostSend (
                    color: "danger",
                    channel: 'Sunfire-CICD-Pacman',
                    endpoint: 'http://10.18.99.155:8065/hooks/dr1fon6aqtfydbe1srk4t7ujec',
                    message: "${fmsg}"
                )
                break;
        }*/
    }
}

pipeline { 
    environment {
        registry = "docker.io/399278/sunfiretechnologies"
        registryCredential = '0c9546ab-84c9-436f-b324-ff78b2c0fc30'
    }
    agent any
    triggers {
        pollSCM '* * * * *'
    }
    options {
        skipStagesAfterUnstable()
    }
    

    stages {
        stage('Build') { 
            steps { 
                sh 'git clone https://github.com/Sagar-Dahat/pacman2.git pacman.v$BUILD_NUMBER' 
				echo "${currentBuild.currentResult}"
                feedback("${currentBuild.currentResult}",'Git Clone Successful','Git Clone Failed')
            }
        }
        stage('sonar-scanner') {
            steps {
                sh './sonarqube.sh'
                feedback("${currentBuild.currentResult}",'Code Quality Passed','Code Quality Failed')
            }
        }
        stage('Copy'){
            steps {
                sh 'sudo echo -y | sudo cp -rf pacman.v$BUILD_NUMBER/ /var/www/html/'
                feedback("${currentBuild.currentResult}",'Transfer Successful','Transfer Failed')
            }
        }

        stage('containerize/create pacman image') {
            steps {
                sh 'docker build -t pacman:v$BUILD_NUMBER .'
                feedback("${currentBuild.currentResult}",'Build Successful','Build Failed')
            }
        }
        stage('tag image') {
            steps {
                sh 'docker tag pacman:v$BUILD_NUMBER 399278/sunfiretechnologies:v$BUILD_NUMBER'
                feedback("${currentBuild.currentResult}",'Image Tagging Successful','Image Tagging Failed')
            }
        }
        
        stage('push image') {
            steps {
                sh 'sudo docker push 399278/sunfiretechnologies:v$BUILD_NUMBER'
                feedback("${currentBuild.currentResult}",'Image to Harbor Successful','Image to Harbor Failed')
            }
        }
        
        stage('cleanup previous deployment') {
            steps {
                sh './kill.sh'
            }
        }
        
        stage('run image') {
            steps {
                sh 'sudo docker run -dit -p 80:80 399278/sunfiretechnologies:v$BUILD_NUMBER --name=pacman:v$BUILD_NUMBER '
            }
        } 
        
        stage('Check if deployed') {
            steps {
                echo 'Check Browser - ipaddress:80'
                feedback("${currentBuild.currentResult}",'Deploy Successful','Deploy Failed')
            }
        }
    }
}