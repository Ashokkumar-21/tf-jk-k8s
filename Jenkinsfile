pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '098588167308'
        CLUSTER = 'devops-eks-cluster'
        ECR_REPO = 'static-nginx'
    }

    stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Inject AWS Credentials') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws_credentials',
                                          usernameVariable: 'AWS_ACCESS_KEY_ID',
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh '''
            echo "==> Identity check"
            aws sts get-caller-identity

            echo "==> Terraform Init"
            terraform init -reconfigure

            echo "==> Terraform Apply"
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Configure kubectl for EKS') {
      steps {
        sh 'aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER}'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${ECR_REPO}:latest .'
      }
    }

    stage('Login to ECR') {
      steps {
        sh '''
          aws ecr get-login-password --region ${AWS_REGION} | \
          docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
        '''
      }
    }

    stage('Tag & Push Image to ECR') {
      steps {
        sh '''
          docker tag ${ECR_REPO}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
          docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
          kubectl apply -f deployment.yaml
          kubectl apply -f service.yaml
        '''
      }
    }
  }
}
