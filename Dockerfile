FROM golang:1.23-bullseye AS builder
WORKDIR /src

# Copy shared library first
COPY shared/ ./shared/

# Copy service files
COPY enroll/go.mod enroll/go.sum ./enroll/
WORKDIR /src/enroll
RUN go mod download

WORKDIR /src
COPY enroll/ ./enroll/
WORKDIR /src/enroll
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/enroll ./cmd/enroll

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /out/enroll /usr/local/bin/enroll
COPY enroll/config/ /config/
EXPOSE 8080 9090
ENTRYPOINT ["/usr/local/bin/enroll"]
