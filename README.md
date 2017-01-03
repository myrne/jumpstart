# Jumpstart: Juice to get going [![Build Status](https://travis-ci.org/braveg1rl/jumpstart.png?branch=master)](https://travis-ci.org/braveg1rl/jumpstart) [![Dependency Status](https://david-dm.org/braveg1rl/jumpstart.png)](https://david-dm.org/braveg1rl/jumpstart)

Jumpstart creates new projects from templates with placeholders.

## Installation

You probably want to install jumpstart globally, so you can run it from anywhere.
To get a sense of what jumpstart can do, you should install a template module as well. Currently, [Jumpstart Black Coffee](https://github.com/braveg1rl/jumpstart-black-coffee) is the only one publicly available, so that makes it easy to choose.

```
npm install jumpstart -g
npm install jumpstart-black-coffee -g
```

## Configuration

Jumpstart searches for a `.jumpstart.json` file within

1. the current work directory
2. your home directory -- for global configuration

Currently Jumpstart solely looks for a `globals` property inside the JSON data. If you specificy values for placeholders here, Jumpstart will use them to fill out the template, without asking you for it.

Placeholder names conform to the following pattern: `[a-z]+(-[a-z]+)*`, i.e. lowercase words separated with a dash (`-`).

Jumpstart will work without a configuration file, but it will be much less convenient to use.

###  Example of a .jumpstart.json file

Below is the `.jumpstart.json` file that I currently use for [my open source projects](https://github.com/braveg1rl/?tab=repositories). It defines values for most of the placeholders inside my [Jumpstart Black Coffee](https://github.com/braveg1rl/jumpstart-black-coffee) template.

```javascript
{
  "globals": {
    "author-name": "Braveg1rl",
    "author-email": "braveg1rl@outlook.com",
    "github-username": "braveg1rl",
    "github-ownername": "braveg1rl",
    "github-repos-path": "/user/repos",
    "module-is-private": "false",
    "node-version": "0.10.x",
    "npm-version": "1.2.x",
    "commit-message": "jumpstart commit."
  }
}
```

#### A note about `module-is-private`

This property is set to the string `"false"`. This is because Jumpstart does not know about booleans. Because of how the [Jumpstart Black Coffee](https://github.com/braveg1rl/jumpstart-black-coffee) template is structured, setting this property to anything else than `"true"` or `"false"` would reduce in invalid JSON in the generated project.

## Usage

Typically, you run jumpstart from your 'Work' directory (i.e. the directory that holds your project directories).

```
jumpstart [dirname] [template-name]
```

Jumpstart will search for a jumpstart template module within

1. the current working directory
2. the directory in which the jumpstart module is installed. This allows for distributing template modules via npm.

Jumpstart will read all files inside the jumpstart template and look for placeholders. Jumpstart will then ask for values of any placeholders it doesn't know a value for (either built-in or provided through a `.jumpstart.json` config file).

After getting values for all variables, Jumpstart creates the target directory, copies the contents of the template directory into the target directory and replaces the placeholders with their provided values. As a precaution, Jumpstart won't write to a directory that already exists.

At the moment the program's output is quite verbose, which helps with debugging, as well as understanding what's going on.


## Creating  jumpstart template modules

A jumpstart template module is a directory which name starts with `jumpstart-` followed by the module name. A jumpstart template module should contain a `template` directory which holds the actual template (freeing up the module root for metadata).

The files inside the template directory serve as templates for the files in the target directory. The template files are copied verbatim to the target directory, with the following exceptions:

### 1. Placeholder replacement

A placeholder string is a variable name with three dashes added on both sides. Examples of placeholders:

* `---name---`
* `---author-email---`
* `---some-important-setting---`

Placeholders can be placed anywhere, both inside and outside of what are considered strings in a particular language. This means the template files themselves may not be valid.

### 2. Special file names

To allow easy distribution of templates through npm, and to prevent any conflicts in what you want the template to be compared with how you want to edit it, jumpstart templates use special names for the following files:

* `package.json` -- `package.jumpstart.json`
* `.tm_properties` -- `tm_properties.jumpstart`
* `.gitignore` -- `gitignore.jumpstart`
* `.npmignore` -- `npmignore.jumpstart`

After copying all files to the target directory and applying values to placeholders.

### Example file template (taken from a Makefile)

```
jumpstart:
	curl -u '---github-username---' https://api.github.com---github-repos-path--- -d '{"name":"---module-name---", "description":"---module-description---","private":---module-is-private---}'
	touch src/---module-name---.coffee
	git init
	git remote add origin git@github.com:---github-ownername---/---module-name---
	git add *
	git commit -m "---commit-message---"
	git push -u origin master
```

## Using a template module

The easiest way to use your own template is to place it in your Work directory with the name `jumpstart-yourtemplate`. In your Work directory, you can then do `jumpstart yournewproject yourtemplate`.

## Publishing a template module

The structure of a template module allows it to be published verbatim with npm. The module name (i.e. in package.json) must start with `jumpstart-`.

## License
Jumpstart is released under the [MIT License](http://opensource.org/licenses/MIT).  
Copyright (c) 2017 Braveg1rl
