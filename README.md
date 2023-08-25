# BUILD IMAGE & PUSH
```bash
$ aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 376971950426.dkr.ecr.ap-southeast-1.amazonaws.com
$ docker build --platform=linux/amd64 -t  376971950426.dkr.ecr.ap-southeast-1.amazonaws.com/hrforte:<image_tag> .
$ docker push 376971950426.dkr.ecr.ap-southeast-1.amazonaws.com/hrforte:<image_tag>
```

# TERRAFORM
```bash
$ terraform init
$ terraform apply
$ terraform destroy
```