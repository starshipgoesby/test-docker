# Start from a base image containing the Go runtime
FROM golang:1.17 AS builder

# Set the current working directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies using go mod
RUN go mod download

# Copy the source code from the host to the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Start a new stage from scratch
FROM alpine:latest

# Set the working directory to /app in the new stage
WORKDIR /app

# Copy the compiled binary from the builder stage to the new stage
COPY --from=builder /app/app .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./app"]
