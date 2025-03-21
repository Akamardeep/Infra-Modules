pipeline {
    agent any

    environment {
        GITHUB_REPO = "https://github.com/Akamardeep/Infra-Modules.git"
        EC2_USER = "ec2-user"
        EC2_HOST = "35.173.235.232"
    }

    stages {
        stage('Deploy Code to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'EC2_SSH_KEY', keyFileVariable: 'SSH_KEY_FILE')]) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY_FILE $EC2_USER@$EC2_HOST <<EOF
                        echo "Connected to EC2"

                        # Full path check and removal if the directory exists
                        if [ -d "/home/ec2-user/Infra-Modules" ]; then
                            echo "Removing existing directory /home/ec2-user/Infra-Modules"
                            rm -rf /home/ec2-user/Infra-Modules
                        else
                            echo "Directory /home/ec2-user/Infra-Modules does not exist. Skipping removal."
                        fi

                        # Clone fresh repository into the target directory
                        git clone https://github.com/Akamardeep/Infra-Modules.git /home/ec2-user/Infra-Modules
                        ls
                        pwd
                        cd Infra-Modules
                        pwd 
                        ls

                        echo "Deployment successful"
                        
                    '''
                }
            }
        }
    }
}
