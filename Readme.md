This is Terraform file to start single Ec2 instance on ap-south-1 reagion.
Created mail.tf file with all the below resources.

* provider `aws`
    * resource `aws_vpc`
    * resource `aws_internet_gateway`
    * resource `aws_subnet` /Public_subnet
    * resource `aws_subnet` /Private_subnet
    * resource `aws_security_group`
    * resource `aws_instance`


#### Command to run

```
terraform init
terraform validate
terraform plan
terraform apply (yes)
terraform destroy (yes)
```