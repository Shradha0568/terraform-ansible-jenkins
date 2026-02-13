terraform {
  backend "s3" {
    bucket = "terraform-ansible-task-statefile"
    key    = "server_name/statefile"
    region = "us-west-2"
  }
}

