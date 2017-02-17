set -e

API="https://api.fr.cloud.gov"
ORG="gsa-18f-dolores"
SPACE=$1

if [ $SPACE = 'prod' ]; then
  NAME="dolores-app"
  CF_USERNAME=$CF_USERNAME_PRODUCTION
  CF_PASSWORD=$CF_PASSWORD_PRODUCTION
  MANIFEST="manifest.yml"
elif [ $SPACE = 'staging' ]; then
  NAME="dolores-staging"
  CF_USERNAME=$CF_USERNAME_STAGING
  CF_PASSWORD=$CF_PASSWORD_STAGING
  MANIFEST="manifest_staging.yml"
else
  echo "Unknown space: $SPACE"
  exit
fi

cf login -a $API -u $CF_USERNAME -p $CF_PASSWORD -o $ORG -s $SPACE
cf push -f $MANIFEST
