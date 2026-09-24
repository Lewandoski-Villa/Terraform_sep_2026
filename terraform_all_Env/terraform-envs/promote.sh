#!/usr/bin/env bash
# Usage: ./promote.sh            -> dev, then uat, then prod (asks before each apply)
#        ./promote.sh dev        -> only dev
#        ./promote.sh dev uat    -> dev, then uat
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
ENVS="${*:-dev uat prod}"

for env in $ENVS; do
  echo "================ $env ================"
  cd "$ROOT/envs/$env"
  terraform init -input=false
  terraform validate
  terraform plan -out=tfplan
  read -r -p "Apply to $env? (yes/no): " ans
  [ "$ans" = "yes" ] || { echo "Stopped before $env. Nothing promoted further."; exit 1; }
  terraform apply tfplan
  rm -f tfplan
done
echo "Done: $ENVS"
