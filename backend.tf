terraform {
  backend "s3" {
    bucket         = "my-s3-bucket-new-tf-1"     # Replace with your S3 bucket
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
