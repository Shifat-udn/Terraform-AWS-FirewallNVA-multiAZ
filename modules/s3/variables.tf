variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "name_tags" {
  description = "A map of tags to assign to the bucket"
  type        = string
}
variable "region"{
  description = "The AWS region where the S3 bucket will be created"
  type        = string
}
