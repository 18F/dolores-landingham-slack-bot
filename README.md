# Dolores Landingham Bot

[![Build Status](https://travis-ci.org/18F/dolores-landingham-bot.svg?branch=master)](https://travis-ci.org/18F/dolores-landingham-bot)
[![Code Climate](https://codeclimate.com/github/18F/dolores-landingham-bot/badges/gpa.svg)](https://codeclimate.com/github/18F/dolores-landingham-bot)
![Dolores](http://seattletimes.nwsource.com/ABPub/2006/05/11/2002987603.jpg)

This is a Slack bot that helps onboard new hires at 18F through scheduled Slack
messages about topics relevant to 18F and GSA employees. Messages will be
scheduled once per day and will trickle out to employees over the course of 60
days.

Mrs. Landingham will teach 18F employees about working in the federal
government, how to set up travel, how to add their biographical information and
pictures to our website, and other facts that will help them get acclimated to
both 18F and the federal government.

Please file an issue if you have any questions about Mrs. Landingham.

The name of this bot is a friendly reference to the TV show *The West Wing*, where Mrs. Landingham is the fictional president's trusted secretary. This photo is from the show.

## Usage instructions for 18F employees

**To add new users**

1. Go https://dolores-app.18f.gov/
2. Click https://dolores-app.18f.gov/employees/new
3. Write their Slack username without the @ symbol
4. Select the date that they started
5. Select the time zone that they reside in
6. Click https://dolores-app.18f.gov/employees to make sure they’re on the list

**To add new messages**

1. Draft the message in this [issue](https://github.com/18F/dolores-landingham-bot/issues/115)
2. Admins can copy the message and paste it in the message body here: https://dolores-app.18f.gov/scheduled_messages/new
3. Add a title to your message to be able to identify the message
4. Add the number of days after an employee starts. (Add 1 to the last message in this Google Doc)
5. Select a time that the message should be sent (the message will be sent at each employee's local time)
6. Add tags to be able to surface the message

## Installing and contributing

If you're interested in setting up a version of this bot or contributing to this one, our [contribution guidelines](CONTRIBUTING.md) explain how to set up and deploy this app, find potential tasks to work on, and submit pull requests.

## Using Dolores

18F employees can view the scheduled messages that Dolores sends employees by visiting
https://dolores-app.18f.gov/.

Any 18F employee with a Slack handle can add themselves as a Dolores Landingham
message recipient [here](https://dolores-app.18f.gov/).

Only admin users can add and update scheduled messages. If you would like to
add or update scheduled messages, please DM Melody Kramer on Slack or open an
Issue on this repo.

Admin users can add scheduled messages
[here](https://dolores-app.18f.gov/scheduled_messages/new).

Scheduled messages include a "day count" attribute. Messages to be sent on the
day an employee starts have a day count of 0, messages to be sent the next day
should have a day count of 1, and so on.

## Questions?

If you have any questions about the Dolores Bot project and are internal to 18F,
you can chat with us in the [#bots](https://18f.slack.com/messages/bots/) Slack
channel.

If you are not internal to 18F and have a question, we would be delighted to
help. Please [open a GitHub
issue](https://github.com/18F/dolores-landingham-bot/issues/new) and we will get back to
you as soon as we can.

## Public domain

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).

For more information, see [license](LICENSE.md).
