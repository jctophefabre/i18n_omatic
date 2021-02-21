# Contributing to i18n_omatic

:tada: First off, thanks for your contributions! :+1:

You can contributhe to the [i18n_omatic](https://github.com/jctophefabre/i18n_omatic) package by many ways:
* [Issues](#contributing-with-issues)
* [Code](#contributing-with-code)


## Contributing with issues

Contributing with issues is very important to improve the quality of the package. You can open issues to:
* Declare a found bug
* Suggest a new feature
* Ask for documentation
* Discuss with other users and the owner of the package
* ...

Before opening a new issue, please consult the [list of already opened issues](https://github.com/jctophefabre/i18n_omatic/issues) to avoid creating a duplicate issue.

When you open an issue, provide a title and a comprehensive description to give a clear idea on what the issue is.

If the issue is related to another existing issue, mention it using the `#` notation. (e.g. `This issue is related to #5`)


## Contributing with code

When contributing to the code of this repository, please first discuss the changes you wish to make with the owner of this repository before submitting a pull request. You can open a specific issue for that.


### Coding style

The coding style applied in the i18n_omatic code is the [official dart coding style](https://dart.dev/guides/language/effective-dart/style). You are encouraged to consider it and to apply it in your contributions.


### Testing

We recommend to run the tests regurlarly during your development process. The tests are run using the following command:
```
dart pub run test
```

You are also encouraged to add new tests to cover your contributed code. See the [test directory](https://github.com/jctophefabre/i18n_omatic/tree/master/test) for already existing tests.


### Commits style

#### Content

Commits must be as atomic as possible. Each commit should be related to a single consistent improvement : a single bug fix, a single new feature, ...  
If you contribution is made of multiple improvements, it should be made through multiple commits.  
However, in some cases multiple changes can be gathered into a single commit as their are tightly related and cannot be splitted in multiple commits.  

#### Messages

Commits messages must compound a simple title, an optional list of changes and an optional relation to an existing issue:  
* the title must be a simple sentence
* (optional) each item of the list of changes must start with an asterisk followed by a verb in past tense (e.g. Added ..., Updated ..., Fixed ...)
* (optional) the related issue must be marked as "references" if the commit is just in relation with the issue, or "closes" it it closes it. This relation is written between parentheses.

These 3 parts are separated by a blank line.


Complete example:
```text
 Fix of crash when translations directory does not exist

* Fixed uncaught exception in discoverTranslationsFiles()
* Updated console display of update command-line
* Cleaned code

(closes #4)
```

Example with the title only:
```text
Update of package description 
```

### Pull-request process

A pull-request must be targetted to a clearly identified improvement, made of one to 3 commits for an easier integration. As already written, your are really encouraged to first discuss the changes you wish to make with the owner of the i18n_omatic package.

Before you submit your pull-request, check that you applied these guidelines ([coding style](#coding-style), [testing](#testing), [commits style](#commits-style), ...)

Once you have subitted, your pull-request will be reviewed then can be integrated as-is or after a discussion with the owner of this repository.