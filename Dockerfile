# Builder image
FROM golang:1.12 as builder
RUN go get -v github.com/Didstopia/steamer
WORKDIR /go/src/github.com/Didstopia/steamer/
RUN git checkout master
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o steamer .
#RUN steamer --appinfo 748090



# Primary image
FROM didstopia/base:steamcmd-ubuntu-16.04

MAINTAINER Didstopia <support@didstopia.com>

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    net-tools \
    jq \
    cron \
    rsyslog \
    mono-complete && \
	rm -rf /var/lib/apt/lists/*

# Create and set the steamcmd folder as a volume
RUN mkdir -p /steamcmd/colonysurvival
VOLUME ["/steamcmd/colonysurvival"]

# Add the steamcmd installation script
ADD install.txt /install.txt

# Copy any scripts
ADD start.sh /start.sh
ADD update.sh /update.sh

# Make sure they're executable
RUN chmod +x /*.sh

# Copy the compiled Go app
COPY --from=builder /go/src/github.com/Didstopia/steamer/steamer /usr/bin

# Add the crontab
ADD crontab /update.cron

# Set the current working directory
WORKDIR /

# Expose necessary ports
#EXPOSE 27004/tcp
#EXPOSE 27004/udp
EXPOSE 27016/tcp
EXPOSE 27016/udp
EXPOSE 27017/tcp

# Setup default environment variables for the server
ENV SERVER_NAME "Docker"
ENV SERVER_PASSWORD ""

# Test that the Go app works
#RUN steamer --appinfo 748090

# Start the server
ENTRYPOINT ["./start.sh"]
