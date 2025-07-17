pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '098588167308'    
        ECR_REPO_NAME = 'jenkins'           
        IMAGE_TAG = 'v2'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        FULL_IMAGE_NAME = "${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}"
    }

    stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Apply - Create EKS & ECR') {
      steps {
        dir('tf-jk-k8s') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
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
          docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
        '''
      }
    }

    stage('Tag & Push Image to ECR') {
      steps {
        sh '''
          docker tag ${ECR_REPO}:latest ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
          docker push ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest
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
