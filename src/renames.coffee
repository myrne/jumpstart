module.exports =
  "package.jumpstart.json": "package.json" # so npm won't complain about invalid syntax because of placeholders
  "gitignore.jumpstart": ".gitignore" # .gitignore is not included when packaged by npm
  "npmignore.jumpstart": ".npmignore" # will be included, possibly overwrites the original .npmignore
  "tm_properties.jumpstart": ".tm_properties" # so the textmate properties won't apply to the template dir itself