## Dolores Landingham Bot

![Dolores](http://seattletimes.nwsource.com/ABPub/2006/05/11/2002987603.jpg)

This is a Slack bot that helps onboard new hires at 18F through scheduled Slack
messages about topics relevant to GSA employees.

### Contributing

Please read the [contribution guidelines](CONTRIBUTING.md) before submitting a pull request.

### Public domain

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).

For more information, see [license](LICENSE.md).


## Deployment

Refer to [docs.18f.gov](https://docs.18f.gov/getting-started/setup/) for getting set up with Cloud Foundry


To deploy:
`cf target -o 18f -s dolores` 

`cf set-env dolores HOST dolores-app.18f.gov`
`cf set-env dolores APPLICATION_HOST dolores-app.18f.gov`
`cf set-env dolores ASSET_HOST dolores-app.18f.gov`
`cf set-env dolores DEFAULT_URL_HOST dolores-app.18f.gov`

To push to production:
`cf push dolores`
To push to staging
`cf push dolores-staging`

