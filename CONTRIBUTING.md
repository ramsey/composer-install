# Contributing

Contributions are welcome. This project accepts pull requests on [GitHub][].

This project adheres to a [code of conduct](CODE_OF_CONDUCT.md). By
participating in this project and its community, you are expected to uphold this
code.

## Communication Channels

You can find help and discussion in the following places:

* GitHub Issues: <https://github.com/ramsey/composer-install/issues>

## Reporting Bugs

Report bugs using the project's [issue tracker][issues].

⚠️ _**ATTENTION!!!** DO NOT include passwords or other sensitive information in
your bug report._

When submitting a bug report, please include enough information to reproduce the
bug. A good bug report includes the following sections:

* **Description**

  Provide a short and clear description of the bug.

* **Steps to reproduce**

  Provide steps to reproduce the behavior you are experiencing. Please try to
  keep this as short as possible. If able, create a reproducible script outside
  of any framework you are using. This will help us to quickly debug the issue.

* **Expected behavior**

  Provide a short and clear description of what you expect to happen.

* **Screenshots or output**

  If applicable, add screenshots or program output to help explain your problem.

* **Environment details**

  Provide details about the system where you're using this package, such as PHP
  version and operating system.

* **Additional context**

  Provide any additional context that may help us debug the problem.

## Fixing Bugs

This project welcomes pull requests to fix bugs!

If you see a bug report that you'd like to fix, please feel free to do so.
Following the directions and guidelines described in the "Adding New Features"
section below, you may create bugfix branches and send pull requests.

## Adding New Features

If you have an idea for a new feature, it's a good idea to check out the
[issues][] or active [pull requests][] first to see if anyone is already working
on the feature. If not, feel free to submit an issue first, asking whether the
feature is beneficial to the project. This will save you from doing a lot of
development work only to have your feature rejected. We don't enjoy rejecting
your hard work, but some features don't fit with the goals of the project.

When you do begin working on your feature, here are some guidelines to consider:

* Your pull request description should clearly detail the changes you have made.
  We will use this description to update the CHANGELOG. If there is no
  description, or it does not adequately describe your feature, we may ask you
  to update the description.
* Please **write tests** for any new features you add.
* Please **ensure that tests pass** before submitting your pull request.
  ramsey/composer-install automatically runs tests for pull requests. However,
  running the tests locally will help save time. _Hint: run `composer test`._
* **Use topic/feature branches.** Please do not ask to pull from your main branch.
    * For more information, see "[Understanding the GitHub flow][gh-flow]."
* **Submit one feature per pull request.** If you have multiple features you
  wish to submit, please break them into separate pull requests.
* **Write good commit messages.** This project follows the
  [Conventional Commits][] specification and uses Git hooks to ensure all
  commits follow this standard. Running `composer install` will set up the Git
  hooks, so when you run `git commit`, you'll be prompted to create a commit
  using the Conventional Commits rules.

## Developing

To develop this project, you will need [PHP](https://www.php.net),
[Composer](https://getcomposer.org), [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)),
and [Expect](https://en.wikipedia.org/wiki/Expect).

### Running Tests

This project includes a suite of tests located in `tests/expect/`. These tests
use the `expect` command to automate CLI interactions. The tests will run
automatically as part of continuous integration, or you may run them locally with:

```
composer test
```

To run the tests, you must have an up-to-date version of coreutils (8.30 or
later).

To generate a new test:

```
cd tests/expect/
autoexpect ../../bin/path-to-script-to-test.sh
```

`autoexpect` will save the test to `script.exp`. Rename it with a more
descriptive name, and run it to ensure it does what you expect: `./script.exp`.
You may need to edit the test file or add to it, according to your needs.

Expect is an extension to the [Tcl](https://en.wikipedia.org/wiki/Tcl) scripting
language, so it may be helpful to learn a little about Tcl as you write tests.

When done, `cd ../..` and run `composer test`.
Your new test should run along with the other tests.

[github]: https://github.com/ramsey/composer-install
[issues]: https://github.com/ramsey/composer-install/issues
[pull requests]: https://github.com/ramsey/composer-install/pulls
[gh-flow]: https://guides.github.com/introduction/flow/
