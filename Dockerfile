# Build server stage
FROM golang:1.19 as Server
WORKDIR /server
ENV CGO_ENABLED 0
ENV GOOS linux
COPY go.* ./
COPY . ./
RUN go mod tidy
RUN go mod vendor
RUN go build -a -installsuffix cgo -o binary .

# Production stage
FROM scratch
COPY --from=Server /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=Server /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=Server /server/binary ./

EXPOSE 3000
ENTRYPOINT ["./binary"]
