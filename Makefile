.PHONY: build test lint docker run-local clean

build:
	go build -o bin/enroll ./cmd/enroll

test:
	go test ./... -v

lint:
	golangci-lint run ./...

docker:
	docker build -t gigvault/enroll:local .

run-local: docker
	../infra/scripts/deploy-local.sh enroll

clean:
	rm -rf bin/
	go clean
