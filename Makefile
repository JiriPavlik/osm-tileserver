.PHONY: build push test

build:
	docker build -t hhansen06/osm-tileserver .

push: build
	docker push hhansen06/osm-tileserver:latest

test: build
	docker run -p 80:80 -d hhansen06/osm-tileserver run
