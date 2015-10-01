## Dolores Landingham Bot

![Dolores](http://seattletimes.nwsource.com/ABPub/2006/05/11/2002987603.jpg)

This is a Slack bot that helps onboard new hires at 18F through scheduled Slack
messages about topics relevant to 18F and GSA employees. Messages will be
scheduled once per day and will trickle out to employees over the course of 60
days.

Mrs. Landingham will 18F employees about working in the federal government, how
to set up travel, how to add their biographical information and pictures to our
Hub, and other facts that will help them get acclimated to both 18F and the
federal government.

### Contributing

Please read the [contribution guidelines](CONTRIBUTING.md) before submitting a pull request.

### Not sure what to work on?

Check out the [Dolores Bot Waffle.io
board](https://waffle.io/18F/dolores-landingham-bot) and pick out something in
the "Up next" column. Make sure you move the feature you're working on the "In
progress" and assign it to yourself so we all know who is working on what.

### Questions?

If you have any questions about the Dolores Bot project and are internal to 18F,
you can chat us up in the [#bots](https://18f.slack.com/messages/bots/) Slack
channel.

If you are not internal to 18F and have a question, we would be delighted to
help. Please [open a GitHub
issue](https://github.con/18F/dolores-landingham-bot/issues/new) and we will get back to
you as soon as we can.

### Public domain

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).

For more information, see [license](LICENSE.md).

## Deployment

Refer to [docs.18f.gov](https://docs.18f.gov/getting-started/setup/) for getting
set up with Cloud Foundry

The Dolores Landingham bot is deployed within the 18F org in Cloud Foundry. If
you do not already have access to the 18F org, you can request access by posting
an issue to the [DevOps repo](https://github.com/18F/DevOps/issues/new) on
GitHub.

Once you have access to the 18F org, you can target the Cloud Foundry
organization and space for this project:

`cf target -o 18f -s dolores`

Then, you can push to production:

`cf push dolores-app`

New migrations will be run automatically. See the [manifest](manifest.yml) for
more details on the Cloud Foundry setup.

To see existing environment variables on production:

`cf env dolores-app`

To set or change the value of an environment variable on production:

`cf set-env dolores-app <env-name> <env-value>`
