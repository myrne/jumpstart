# npm install courier -g
# courier

name: "jumpstart"
description: "Quickly build modules based on templates."
keywords: []
version: "0.0.1"
author: "Meryn Stol <merynstol@gmail.com>"
homepage: "https://github.com/stellarpad/jumpstart"
repository:
  type: "git"
  url: "git://github.com:stellarpad/jumpstart.git"

directories:
  lib: "./lib"
main: "lib/jumpstart.js"
dependencies:
  async: "0.2.x"
  optimist: "0.3.x"
  commander: "1.1.x"
  ncp: "0.4.x"
  "recursive-readdir": "0.0.1",
  "easy-table": "0.2.x"
  "fs.extra": "1.2.x"

devDependencies:
  "coffee-script": "1.6.x"
optionalDependencies: {}

engines:
  node: "0.10.x"
  npm: "1.2.x"

bin:
  jumpstart: "./bin/jumpstart"

scripts:
  prepublish: "npm test"
  pretest: "make build"
  test: "make test"