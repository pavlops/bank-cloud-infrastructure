# bank-cloud-infrastructure

This is a sample cloud infrastructure in AWS for the BCI Company done in Terraform.

## Prerequisites
- aws-cli => 1.18.69
- Terraform => 0.15.0

## Deployment steps

1) Set the AWS credentials in the deployment machine.
2) Init the Terraform modules:
```terraform init
```

2) Plan the Terraform execution:
```terraform plan
```

3) Apply the Terraform planned changes:
```terraform apply --auto-aprove
```

## Author

**Pablo Suarez**

## License

Apache License. Version 2.0, January 2004.
