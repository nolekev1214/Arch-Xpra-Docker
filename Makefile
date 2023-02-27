# Change this to suit your needs.
TAG:=xpra-html5

all: build

build:
	docker build -t="$(TAG)" .

run:
	docker run -d -p 80:8080 $(TAG)