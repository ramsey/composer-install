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
Composer dependencies in workflows.

This project adheres to a [code of conduct](CODE_OF_CONDUCT.md).
By participating in this project and its community, you are expected to
uphold this code.

## Usage

Use a step within a job:

```yaml
- uses: "ramsey/composer-install@v1"
```

By default, the action will use `composer install` to install dependencies. This
means it will use a `composer.lock` file to install dependencies, if one is
present. Otherwise, it will use the latest versions of dependencies, as defined
in `composer.json`.

To install the highest or lowest versions of dependencies, without respect for
`composer.lock`, use the `dependency-versions` input parameter.

```yaml
- uses: "ramsey/composer-install@v1"
  with:
    dependency-versions: "highest"
```

The `dependency-versions` input parameter may be either `highest`, `lowest`, or
`locked`. By default, it is `locked`.

You may also pass additional options to the `composer` command:

```yaml
- uses: "ramsey/composer-install@v1"
  with:
    dependency-versions: "lowest"
    composer-options: "--ignore-platform-reqs"
```

## Contributing

Contributions are welcome! Before contributing to this project, familiarize
yourself with [CONTRIBUTING.md](CONTRIBUTING.md).

## Copyright and License

The ramsey/composer-install GitHub Action is copyright © [Ben Ramsey](https://benramsey.com)
and licensed for use under the terms of the MIT License (MIT). Please see
[LICENSE](LICENSE) for more information.
