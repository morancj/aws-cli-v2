# aws-cli-v2

## Introduction

This is an unofficial *experimental* build of AWS CLI v2 for [Arch Linux](https://www.archlinux.org/) and [Docker](https://www.docker.com/). A Docker image can be downloaded from [Docker Hub](https://hub.docker.com/repository/docker/morancj/aws-cli-v2).

## Running under Docker on Linux

Set up a shell alias similar to this one:

```zsh
alias docker-aws2="docker run\
 --cap-drop=all\
 --memory=1GB\
 --rm\
 -i\
 -t\
 -v \$HOME/.aws:/srv/.aws\
 -v /etc/group:/etc/group:ro\
 -v /etc/passwd:/etc/passwd:ro\
 -u=\$(id -u):\$(id -g)\
 -e HOME=/srv\
 --name aws-cli-v2\
 morancj/aws-cli-v2:2.0.0dev3-0.0.1\
 aws"
```

You can now run `docker-aws2` commands. Try `docker-aws2 help`.

Testing has been *minimal*, but the `sso login` and `help` commands work. Using AWS SSO and [aws2-wrap](https://github.com/linaro-its/aws2-wrap) with [Terraform](https://www.terraform.io/) works.

## Using with Terraform and aws2-wrap

Sign-in to AWS SSO with `docker-aws2 sso login --profile=TerraformRoleName`.
Prefix `terraform` with the `aws2-wrap` command.

### Example session

```zsh
➜ docker-aws2 sso login --profile=TerraformRoleName
Attempting to automatically open the SSO authorization page in your default browser.
If the browser does not open or you wish to use a different device to authorize this request, open the following URL:

https://device.sso.us-east-1.amazonaws.com/

Then enter the code:

ABCD-EFGH
Successully logged into Start URL: https://OrgName.awsapps.com/start

Terraform on  develop [$?] took 41s
➜ pipenv run aws2-wrap --profile TerraformRoleName --exec "terraform plan -out=My.plan" | sed 's/\\n/\n/g' | sed 's/\\"/\"/g'
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
```

...snip...
