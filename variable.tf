################################################################################
# Access key
################################################################################

#Accesskey of the user, [accesskey, secretkey]
variable "iam_access_key" {
  type    = list(any)
  default = ["xxxx", "xxxx"]
}

################################################################################
# S3
################################################################################

#Name of s3 to be created and referenced
variable "my_s3_bucket_name" {
  type    = string
  default = "jsungade-redshift-serverless-bucket"
}

################################################################################
# Redshift
################################################################################

#Redshift Serverless config [0 - namespace_name ,1 - admin_user_password, 2 - admin_username, 3 - db_name)]
variable "rssl_config" {
  type    = list(any)
  default = ["rssl-test", "Pass!234", "admin", "jade_test_db"]
}

#RPU capacity
variable "rpu_capacity" {
  type    = number
  default = 32
}