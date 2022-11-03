<h1 align="center">ramsey/composer-install</h1>

<p align="center">
    <strong>A GitHub Action to streamline installation of PHP dependencies with Composer.</strong>
</p>

<p align="center">
    <a href="https://github.com/ramsey/composer-install"><img src="http://img.shields.io/badge/source-ramsey/composer--install-blue.svg?style=flat-square" alt="Source Code"></a>
    <a href="https://github.com/ramsey/composer-install/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-darkcyan.svg?style=flat-square" alt="Read License"></a>
    <a href="https://github.com/ramsey/composer-install/actions?query=workflow%3ACI"><img src="https://img.shields.io/github/workflow/status/ramsey/composer-install/CI?logo=github&style=flat-square" alt="Build Status"></a>
    <a href="https://codecov.io/gh/ramsey/composer-install"><img src="https://img.shields.io/codecov/c/gh/ramsey/composer-install?label=codecov&logo=codecov&style=flat-square" alt="Codecov Code Coverage"></a>
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
- uses: "shivammathur/setup-php@v2"
  with:
    php-version: "latest"
- uses: "ramsey/composer-install@v2"
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
  to running `composer update --prefer-lowest --prefer-stable`)

For example:

```yaml
- uses: "ramsey/composer-install@v2"
  with:
    dependency-versions: "lowest"
```

#### composer-options

ramsey/composer-install always passes the `--no-interaction`, `--no-progress`,
and `--ansi` options to the `composer` command. If you'd like to pass additional
options, you may use the `composer-options` input parameter.

For example:

```yaml
- uses: "ramsey/composer-install@v2"
  with:
    composer-options: "--ignore-platform-reqs --optimize-autoloader"
```

#### working-directory

The `working-directory` input parameter allows you to specify a different
location for your `composer.json` file. For example, if your `composer.json` is
located in `packages/acme-foo/`, use `working-directory` to tell
ramsey/composer-install where to run things.

```yaml
- uses: "ramsey/composer-install@v2"
  with:
    working-directory: "packages/acme-foo"
```

You may use this step as many times as needed, if you have multiple
`composer.json` files.

For example:

```yaml
# Install dependencies using composer.json in the root.
- uses: "ramsey/composer-install@v2"

# Install dependencies using composer.json in src/Component/Config/
- uses: "ramsey/composer-install@v2"
  with:
    working-directory: "src/Component/Config"

# Install dependencies using composer.json in src/Component/Validator/
- uses: "ramsey/composer-install@v2"
  with:
    working-directory: "src/Component/Validator"
```

#### ignore-cache

If you have jobs for which you wish to completely ignore the caching step, you
may use the `ignore-cache` input parameter. When present, ramsey/composer-install
will neither read from nor write to the cache.

Values of `'yes'`, `true`, or `1` will tell the action to ignore the cache. For
any other value, the action will use the default behavior, which is to read from
and store to the cache.

```yaml
- uses: "ramsey/composer-install@v2"
  with:
    ignore-cache: "yes"
```

#### custom-cache-key

There may be times you wish to specify your own cache key. You may do so with
the `custom-cache-key` input parameter. When provided, ramsey/composer-install
will not use the auto-generated cache key, so if your `composer.json` or
`composer.lock` files change, you'll need to update the custom cache key if you
wish to update the cache.

```yaml
- uses: "ramsey/composer-install@v2"
  with:
    custom-cache-key: "my-custom-cache-key"
```

#### custom-cache-suffix

`ramsey/composer-install` will auto-generate a cache key which is composed of
the following elements:
* The OS image name, like `ubuntu-latest`.
* The exact PHP version, like `8.1.11`.
* The options passed via `composer-options`.
* The dependency version setting as per `dependency-versions`.
* The working directory as per `working-directory`.
* A hash of the `composer.json` and/or `composer.lock` files.

If you don't want to generate your own cache key, but do want to make the cache key
even more specific, you can specify a suffix to be added to the cache key via the
`custom-cache-suffix` parameter.

```yaml
# Adds a suffix to the cache key which is equivalent to the full date-time
# of "last Monday 00:00", which means that the cache will be force refreshed
# via the first workflow which is run every Monday.
- uses: "ramsey/composer-install@v2"
  with:
    custom-cache-suffix: $(/bin/date -u --date='last Mon' "+%F")
```

:warning: Note: specifying a `custom-cache-key` will take precedence over the `custom-cache-suffix`.

### Matrix Example

GitHub Workflows allow you to set up a [job matrix](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstrategymatrix),
which allows you to configure multiple jobs for the same steps by using variable
substitution in the job definition.

Here's an example of how you might use the `dependency-versions` and
`composer-options` input parameters as part of a job matrix.

```yaml
strategy:
  matrix:
    php:
      - "7.4"
      - "8.0"
      - "8.1"
    dependencies:
      - "lowest"
      - "highest"
    include:
      - php-version: "8.2"
        composer-options: "--ignore-platform-reqs"

steps:
  - uses: "actions/checkout@v3"
  - uses: "shivammathur/setup-php@v2"
    with:
      php-version: "${{ matrix.php }}"
  - uses: "ramsey/composer-install@v2"
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
