build:
	mkdir -p lib
	coffee --compile -m --output lib/ src/

watch:
	coffee --watch --compile --output lib/ src/
	
test:
	true