terraform {
  backend "s3" {
    bucket         = "my-s3-bucket-new-tf-1"      # your S3 bucket name
    key            = "eks/terraform.tfstate"            # path inside bucket
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"             # use your existing table name
    encrypt        = true
  }
}
