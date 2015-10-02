## Contributing

### Code of conduct

We aspire to create a welcoming environment for collaboration on this project.
To that end, we follow the [18F Code of
Conduct](https://github.com/18F/code-of-conduct/blob/master/code-of-conduct.md)
and ask that all contributors do the same.

### Git Protocol

To contribute to this project, people internal to 18F can create a branch and submit a pull request. If you are external to 18F, you can fork the repository and submit a pull request that way.

We are minimizing commits on the `master` branch by squashing commits and force pushing them to `master`. 

For a more detailed walk through on how to do this, you can read thoughtbot's [Git Protocol](https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature) document.

18f-ers can merge their changes into master after getting approval from another contributor.

### App setup

To get started, run `bin/setup`

After setting up, you can run the application using [foreman]:

    % foreman start

If you don't have `foreman`, see [Foreman's install instructions][foreman]. It
is [purposefully excluded from the project's `Gemfile`][exclude].

[foreman]: https://github.com/ddollar/foreman
[exclude]: https://github.com/ddollar/foreman/pull/437#issuecomment-41110407

The application will run locally at `http://localhost:5000/`. 

If you have previously run a project on a different port, a `.foreman` file 
may be generated at the root of your directory. If so, make sure that this 
file is set to port `5000` or you will be unable to authenticate locally with MyUSA.

### <a name="required-keys">Required Keys</a>

The setup script creates a `.env` file with a dummy environment configuration variables.
If you are internal to 18F and would like access to these configs,
you can contact Jessie Young. Otherwise, you can create a Slack bot
[here](https://18f.slack.com/services/new/bot).

### Authentication

You will need to be on the developer list to authenticate locally via MyUSA.

If you are internal to 18F, contact Brian Hedberg to be added to the developer list.
If you are on the list, `dolores-local` will be one of your [Authorized Applications](https://alpha.my.usa.gov/authorizations) 
on MyUSA.

If `dolores-local` is on your MyUSA list for Authorized Applications and you 
are still unable to authenticate, check with Brian to make sure that the `MYUSA_KEY`
and `MYUSA_SECRET` keys listed in `.env` are up to date.
For more on environmental variables and keys, refer to [Required Keys](#required-keys) above.
