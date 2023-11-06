############################
# STEP 1 build executable binary
############################
FROM golang:1.15-alpine as builder

# Fetch dependencies.
WORKDIR /code
COPY go.mod go.sum /code/
RUN go mod download

# Copy source code
ADD . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build  -o /go/bin/Backend

############################
# STEP 2 build a small image
############################
FROM alpine
# Import from builder.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
# Copy our static executable
RUN true
COPY --from=builder /go/bin/Backend /go/bin/Backend

# Add zoneinfo.zip
ADD https://github.com/golang/go/raw/master/lib/time/zoneinfo.zip /code/zoneinfo.zip
RUN chmod +r /code/zoneinfo.zip
ENV ZONEINFO /code/zoneinfo.zip

# Create appuser
RUN adduser -D -g '' appuser
WORKDIR /code
RUN chown appuser /code


# Use an unprivileged user.
USER appuser

# The service listens on port 8080.
EXPOSE 8080

# Run the parser binary.
ENTRYPOINT ["/go/bin/Backend"]