build:
	mkdir -p lib
	rm -rf lib/*
	node_modules/.bin/coffee --compile -m --output lib/ src/

watch:
	node_modules/.bin/coffee --watch --compile --output lib/ src/
	
test:
	node_modules/.bin/mocha

jumpstart:
	npm install
	curl -u '---github-username---' https://api.github.com---github-repos-path--- -d '{"name":"---module-name---", "description":"---module-description---","private":---module-is-private---}'
	mkdir -p src
	touch src/---module-name---.coffee
	mkdir -p test
	touch test/---module-name---.coffee
	git init
	git remote add origin git@github.com:---github-ownername---/---module-name---
	git add .
	git commit -m "---commit-message---"
	git push -u origin master

.PHONY: test