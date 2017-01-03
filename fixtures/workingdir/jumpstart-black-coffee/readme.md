# jumpstart-black-coffee 

[Jumpstart](https://github.com/braveg1rl/jumpstart) template for an open source npm module written in CoffeeScript, but published as Javascript (including source maps). It also includes handy default settings for Textmate 2.

This template assumes:

* you're using GitHub;
* you want the GitHub repository name to be the same as the npm module name;
* you want to use [Mocha](http://visionmedia.github.io/mocha/) for writing tests, or you don't mind having it available;
* you want to release your code under the [MIT License](http://opensource.org/licenses/MIT).

The generated README.md file also includes status badges for [Travis CI](https://travis-ci.org/) and [David DM](https://david-dm.org/). If you don't like these you could easily remove them though.

If you don't like these assumptions, or any other choices made, you can easily customize the template by forking it and checking out locally.

## Installation

```shell
npm install jumpstart
npm install jumpstart-black-coffee
```

## Configuration
Jumpstart looks for a `.jumpstart.json` file inside your current working directory - or if not found, in your home directory - for global values for the various placeholders.

## Usage

### Starting a new project

```
jumpstart dirname black-coffee
```

You will be asked to provide values for the placeholders inside the `black-coffee` template. Jumpstart then creates a new directory `dirname` containing the filled-out template.

Notes on proper placeholders values:

* `github-repos-path` -- either `/user/repos` or `/orgs/[orgname]/repos` (without the brackets)
* `github-ownername` -- either the same as `github-username`, or your github organization name.
* `module-is-private` -- either the string `true` or the string `false`. Jumpstart does not know about booleans. If you give it any other value (e.g. leave it blank), you'll end up with invalid json in the generated files.

After creating a new project it's recommended you run the following command once:

### Initalizing the new project

```
make jumpstart
```

This command

  * runs `npm install`, which will install the dev-dependencies (coffee-script and mocha)
  * creates a GitHub repo with the specified module name in the specified repos path (for your organization or for yourself)
  * initializes an empty git repository
  * sets the GitHub repository as the local repository's origin
  * creates an empty .coffee file named after the module in both src/ and test/.
  * adds files, and commits with the commit-message you have chosen
  * pushes the repository to GitHub

Running `make jumpstart` afterwards is entirely optional. You could also decide to customize the generated Makefile before running the command.

### Conveniences during development

During development, you can make use of the following commands.

  * `make build` -- compiles all .coffee files in src/ and outputs into lib/.
  * `make watch` -- watches src/ for changes, and compiles any changed .coffee file to lib/.
  * `make test` -- runs mocha tests

These commands require the dev-dependencies to be installed. You can do so with `npm install`.

When you do `npm publish`, the CoffeeScript files will be compiled and all tests will be run, ensuring that the JavaScript code you're publishing is both fresh and working (in so far they're covered by tests).

See also the [Jumpstart documentation](https://github.com/braveg1rl/jumpstart).

## License

jumpstart-black-coffee is released under the [MIT License](http://opensource.org/licenses/MIT).  
Copyright (c) 2017 Braveg1rl