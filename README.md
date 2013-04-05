# Jumpstart: Juice to get going

Use Jumpstart to easily create new projects from templates.

## Usage

```
jumpstart [dirname] [template-name]
```

Jumpstart will search for a jumpstart template module within

1. the current work directory
2. the directory in which the jumpstart module is installed. This allows for distributing template modules via npm, which after installation become globally available.

Jumpstart will read all files inside the jumpstart template and look for placeholders. Jumpstart will then ask for values of any placeholders it doesn't know a value for (either built-in or provided through a .jumpstart.json config file).

After getting values for all variables, Jumpstart creates the target directory, copies the contents of the template directory into the target directory and replaces the placeholders with their provided values. As a precaution, Jumpstart won't write to a directory that already exists.

At the moment the program's output is quite verbose, which helps with debugging, as well as understanding what's going on.

## Configuration

Jumpstart searches for a `.jumpstart.json` file within

1. the current work directory
2. your home directory -- for global configuration

###  Example of a .jumpstart.json file

Variables conform to the following pattern: `[a-z]+(-[a-z]+)*`, i.e. lowercase words separated with a dash (`-`).

```javascript
{
  "globals": {
    "author-name": "Meryn Stol",
    "author-email": "merynstol@gmail.com",
    "github-username": "meryn",
    "github-ownername": "meryn",
    "github-repos-path": "/user/repos",
    "module-is-private": "false",
    "node-version": "0.10.x",
    "npm-version": "1.2.x",
    "commit-message": "jumpstart commit."
  }
}
```

## Creating  jumpstart template modules

A jumpstart template module is a directory which name starts with `jumpstart-` followed by the module name. A jumpstart template module should contain a `template` directory which holds the actual template (freeing up the module root for metadata).

The files inside the template directory serve as templates for the files in the target directory. The template files are copied verbatim to the target directory, with the following exceptions:

### Placeholder replacement

A placeholder string is a variable name with three dashes added on both sides. Examples of placeholders:

* ---name---
* ---author-email---
* ---some-important-setting---

Placeholders can be placed anywhere, both inside and outside of what are considered strings in a particular language. This means the template files themselves may not be valid.

### Special file names

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

## License
Jumpstart is released under the [MIT License](http://opensource.org/licenses/MIT).  
Copyright (c) 2013 Meryn Stol