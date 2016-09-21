set -e

API="https://api.cloud.gov"
ORG="18f"
SPACE="dolores"
ENVIRONMENT=$1

if [ $ENVIRONMENT = 'production' ]; then
  NAME="dolores-app"
elif [ $ENVIRONMENT = 'staging' ]; then
  NAME="dolores-staging"
else
  echo "Unknown environment: $ENVIRONMENT"
  exit
fi

cf login --a $API --u $CF_USERNAME --p $CF_PASSWORD --o $ORG -s $SPACE
cf push $NAME
