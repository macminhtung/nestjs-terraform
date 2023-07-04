# INSTALL PACKAGE
```bash
$ yarn install
```

# BUILD IMAGE & PUSH
```bash
$ aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 924680336081.dkr.ecr.ap-southeast-1.amazonaws.com
$ docker build --platform=linux/amd64 -t  924680336081.dkr.ecr.ap-southeast-1.amazonaws.com/flaia .
$ docker push 924680336081.dkr.ecr.ap-southeast-1.amazonaws.com/flaia:latest
```

# TERRAFORM
```bash
$ terraform init
$ terraform apply
```