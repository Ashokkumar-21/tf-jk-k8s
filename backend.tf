terraform {
  backend "s3" {
    bucket         = "devops-eks-terraform-state"      # your S3 bucket name
    key            = "eks/terraform.tfstate"            # path inside bucket
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"             # use your existing table name
    encrypt        = true
  }
}
