resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-215"

    lifecycle {
        prevent_destroy = false
    } 
}    

resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_dynamodb_table" "terraform_lock" {
  name = "terraform_up_running_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-215"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}