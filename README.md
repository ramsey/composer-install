<h1 align="center">ramsey/composer-install</h1>

<p align="center">
    <strong>A GitHub Action to streamline installation of Composer dependencies.</strong>
</p>

<p align="center">
    <a href="https://github.com/ramsey/composer-install"><img src="http://img.shields.io/badge/source-ramsey/composer--install-blue.svg?style=flat-square" alt="Source Code"></a>
    <a href="https://github.com/ramsey/composer-install/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-darkcyan.svg?style=flat-square" alt="Read License"></a>
    <a href="https://github.com/ramsey/composer-install/actions?query=workflow%3ACI"><img src="https://img.shields.io/github/workflow/status/ramsey/composer-install/CI?logo=github&style=flat-square" alt="Build Status"></a>
    <a href="https://codecov.io/gh/ramsey/composer-install"><img src="https://img.shields.io/codecov/c/gh/ramsey/composer-install?label=codecov&logo=codecov&style=flat-square" alt="Codecov Code Coverage"></a>
    <a href="https://phpc.chat/channel/ramsey"><img src="https://img.shields.io/badge/phpc.chat-%23ramsey-darkslateblue?style=flat-square" alt="Chat with the maintainers"></a>
</p>

## About

ramsey/composer-install is a GitHub Action to streamline installation of
Composer dependencies in workflows. It installs your Composer dependencies and
caches them for improved build times.

This project adheres to a [code of conduct](CODE_OF_CONDUCT.md).
By participating in this project and its community, you are expected to
uphold this code.

## Dependencies

This GitHub Action requires [PHP](https://www.php.net) and
[Composer](https://getcomposer.org). One way to ensure you have both is to use
the [Setup PHP GitHub Action](https://github.com/shivammathur/setup-php).

The step that sets up PHP and Composer for your environment *must* come before
the ramsey/composer-install step.

## Usage

Use ramsey/composer-install as step within a job. This example also shows use of
the [Setup PHP](https://github.com/shivammathur/setup-php) action as a step.

```yaml
- uses: shivammathur/setup-php@v2
  with:
    php-version: "7.4"
- uses: "ramsey/composer-install@v1"
```

:bulb: There is no need to set up a separate caching step since ramsey/composer-install
handles this for you.

### Input Parameters

#### dependency-versions

The `dependency-versions` input parameter allows you to select whether the job
should install the locked, highest, or lowest versions of Composer dependencies.

Valid values are:

* `locked`: (default) installs the locked versions of Composer dependencies
  (equivalent to running `composer install`)

* `highest`: installs the highest versions of Composer dependencies
  (equivalent to running `composer update`)

* `lowest`: installs the lowest versions of Composer dependencies (equivalent
  to running `composer update --prefer-lowest`)

For example:

```yaml
- uses: "ramsey/composer-install@v1"
  with:
    dependency-versions: "lowest"
```

#### composer-options

ramsey/composer-install always passes the `--no-interaction`, `--no-progress`,
and `--ansi` options to the `composer` command. If you'd like to pass additional
options, you may use the `composer-options` input parameter.

For example:

```yaml
- uses: "ramsey/composer-install@v1"
  with:
    composer-options: "--ignore-platform-reqs"
```

#### working-directory

If your `composer.json` is located in a sub-folder (e.g.: `packages/api`), 
you must use `working-directory` input to get the action working properly. 

For example:

```yaml
- uses: "ramsey/composer-install@v1"
  with:
    working-directory: "packages/api"
```

### Matrix Example

GitHub Workflows allow you to set up a [job matrix](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstrategymatrix),
which allows you to configure multiple jobs for the same steps by using variable
substitution in the job definition.

Here's an example of how you might use the `dependency-versions` and
`composer-options` input parameters as part of a job matrix.

```yaml
continue-on-error: ${{ matrix.experimental }}

strategy:
  matrix:
    php:
      - "7.3"
      - "7.4"
    dependencies:
      - "lowest"
      - "highest"
    experimental:
      - false
    include:
      - php: "8.0"
        dependencies: "highest"
        composer-options: "--ignore-platform-reqs"
        experimental: true

steps:
  - uses: "actions/checkout@v2"
  - uses: "shivammathur/setup-php@v2"
    with:
      php-version: "${{ matrix.php }}"
  - uses: "ramsey/composer-install@v1"
    with:
      dependency-versions: "${{ matrix.dependencies }}"
      composer-options: "${{ matrix.composer-options }}"
```

## Contributing

Contributions are welcome! Before contributing to this project, familiarize
yourself with [CONTRIBUTING.md](CONTRIBUTING.md).

## Copyright and License

The ramsey/composer-install GitHub Action is copyright © [Ben Ramsey](https://benramsey.com)
and licensed for use under the terms of the MIT License (MIT). Please see
[LICENSE](LICENSE) for more information.
