#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title AWS Session Token Getter
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 👾
# @raycast.packageName AWS SSO

# Documentation:
# @raycast.description set session_token in profile using AWS single sign-on
# @raycast.author mov
# @raycast.authorURL https://github.com/yuichiro12

aws sso login
id=$(aws configure get sso_account_id)
role=$(aws configure get sso_role_name)
file=$(grep -hr ~/.aws/sso/cache -e accessToken)
token=$(echo "$file" | jq -r .accessToken)
region=$(echo "$file" | jq -r .region)
cred=$(aws sso get-role-credentials --account-id "$id" --role-name "$role" --access-token $token --region "$region")
akid=$(echo "$cred" | jq -r .roleCredentials.accessKeyId)
seckey=$(echo "$cred" | jq -r .roleCredentials.secretAccessKey)
stoken=$(echo "$cred" | jq -r .roleCredentials.sessionToken)
aws configure set aws_access_key_id "$akid"
aws configure set aws_secret_access_key "$seckey"
aws configure set aws_session_token "$stoken"
