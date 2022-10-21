.DEFAULT_GOAL := upload_access_keys_dev
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

test_github_cli:
	@gh --version
	@gh auth status

test_aws_cli:
	@aws --version 1> /dev/null
	@aws sts get-caller-identity | jq -r '.Account'

confirm_aws_account:
	@echo "You are currently signed into account: $$(aws sts get-caller-identity | jq -r '.Account')"
	@echo "\033[0;31mPlease confirm you are authed into an AWS account in the correct organization\033[0m"
	@echo "$$(aws organizations describe-organization | jq -r '.Organization.MasterAccountEmail')"
	@echo -n "[y/N] " && read ans && [ $${ans:-N} = y ]

auth_to_member_account: confirm_aws_account
	@echo "\033[0;31mPlease follow the prompts to auth the CLI into the member account the Terraform Service Account will be created in:\033[0m"
	@echo "\033[0;31mYou must set the profile name to "default"\033[0m"
	@aws configure sso

create_service_account: auth_to_member_account
	@aws iam create-user --user-name "service.$(current_dir).deployer" 

attach_service_account_policy: create_service_account 
	@aws iam put-user-policy --user-name "service.$(current_dir).deployer" --policy-name deployer-policy --policy-document file://deployer-policy.json

upload_access_keys_dev: test_github_cli attach_service_account_policy
	key=$$(aws iam create-access-key --user-name "service.$(current_dir).deployer") \
	gh auth login; \
	echo $$key | jq -r '.AccessKey.AccessKeyId' | gh secret set AWS_ACCESS_KEY_ID --env dev; \
	echo $$key | jq -r '.AccessKey.SecretAccessKey' | gh secret set AWS_SECRET_ACCESS_KEY --env dev;
	@echo "Done"

upload_access_keys_prod: test_github_cli attach_service_account_policy
	key=$$(aws iam create-access-key --user-name "service.$(current_dir).deployer") \
	gh auth login; \
	echo $$key | jq -r '.AccessKey.AccessKeyId' | gh secret set AWS_ACCESS_KEY_ID --env prod; \
	echo $$key | jq -r '.AccessKey.SecretAccessKey' | gh secret set AWS_SECRET_ACCESS_KEY --env prod;
	@echo "Done"
