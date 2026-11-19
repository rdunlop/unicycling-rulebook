# CLAUDE.md

## Deployment and logs

- The app runs on ECS. Deploys go through CI, and the image is what is running in ECS.
- Production and staging logs are in CloudWatch, not on the servers. Do not look for logs in `shared/log/` or any other server path.
- Capistrano (`config/deploy.rb`, `config/deploy/`) is dead and must not be used. Do not run `cap` commands or treat `/home/ec2-user/unicycling-rulebook` as the live app. Removal is tracked in `TODO`.

## Terraform

- Run Terraform only through `terraform/bin/tf <staging|prod> <command> [args]`. Do not run `terraform` directly, and do not run `terraform init` by hand in `terraform/`. The wrapper re-initializes the backend for the environment on every run, which stops a prod plan from using the staging state.
- Read the `bin/tf:` line it prints before reading a plan. It shows the environment, the backend, and the `image_tag` in use.
- Do not put `image_tag` in `terraform/*/terraform.tfvars`. The wrapper uses the image that is running in ECS. Only set `IMAGE_TAG=<sha>` for an intentional rollback.
- Normal deploys go through CI. Local `apply` is only for a break-glass fix, and the wrapper requires you to type the environment name first.
- Claude must never run `terraform apply` or `terraform destroy`, including through `bin/tf`, `-auto-approve`, `-target`, or a saved plan. Robin runs apply himself. Claude can run `plan`, `validate`, `fmt` and `init`.
- Do not commit Terraform state or plan files.
