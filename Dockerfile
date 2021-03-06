# Generated by precisionFDA exporter (v1.0.3) on 2018-06-13 23:42:49 +0000
# The asset download links in this file are valid only for 24h.

# Exported app: url-fetcher, revision: 3, authored by: george.asimenos
# https://precision.fda.gov/apps/app-F0pyzk000GBvX7qVG137gV5Z

# For more information please consult the app export section in the precisionFDA docs

# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

# Install default precisionFDA Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	aria2 \
	byobu \
	cmake \
	cpanminus \
	curl \
	dstat \
	g++ \
	git \
	htop \
	libboost-all-dev \
	libcurl4-openssl-dev \
	libncurses5-dev \
	make \
	perl \
	pypy \
	python-dev \
	python-pip \
	r-base \
	ruby1.9.3 \
	wget \
	xz-utils

# Install default precisionFDA python packages
RUN pip install \
	requests==2.5.0 \
	futures==2.2.0 \
	setuptools==10.2

# Add DNAnexus repo to apt-get
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/amd64/' > /etc/apt/sources.list.d/dnanexus.list"
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/all/' >> /etc/apt/sources.list.d/dnanexus.list"
RUN curl https://wiki.dnanexus.com/images/files/ubuntu-signing-key.gpg | apt-key add -

# Update apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Download app assets
RUN curl https://dl.dnanex.us/F/D/PBYV7GKfzkjvVkpGyP1YpBz3b5bk1jf84vzB2V27/aria2c-1.23.0.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions

# Download helper executables
RUN curl https://dl.dnanex.us/F/D/0K8P4zZvjq9vQ6qV0b6QqY1z2zvfZ0QKQP4gjBXp/emit-1.0.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/bByKQvv1F7BFP3xXPgYXZPZjkXj9V684VPz8gb7p/run-1.2.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions

# Write app spec and code to root folder
RUN ["/bin/bash","-c","echo -E \\{\\\"spec\\\":\\{\\\"input_spec\\\":\\[\\{\\\"name\\\":\\\"url\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":false,\\\"label\\\":\\\"URL\\\",\\\"help\\\":\\\"The\\ URL\\ of\\ the\\ file\\ to\\ be\\ fetched.\\\"\\},\\{\\\"name\\\":\\\"new_name\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":true,\\\"label\\\":\\\"Rename\\ into\\\",\\\"help\\\":\\\"A\\ new\\ name\\ for\\ the\\ downloaded\\ file\\ to\\ be\\ renamed\\ into,\\ if\\ you\\ don\\'t\\ want\\ it\\ to\\ be\\ called\\ by\\ its\\ original\\ name\\ based\\ on\\ the\\ URL.\\\"\\}\\],\\\"output_spec\\\":\\[\\{\\\"name\\\":\\\"fetched_file\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"Fetched\\ file\\\",\\\"help\\\":\\\"The\\ resulting\\ fetched\\ file.\\\"\\}\\],\\\"internet_access\\\":true,\\\"instance_type\\\":\\\"baseline-8\\\"\\},\\\"assets\\\":\\[\\\"file-F0pyyp00qVbGqK5Z893367Jp\\\"\\],\\\"packages\\\":\\[\\]\\} \u003e /spec.json"]
RUN ["/bin/bash","-c","echo -E \\{\\\"code\\\":\\\"\\#\\ Get\\ inside\\ a\\ temp\\ folder\\ to\\ perform\\ the\\ download\\\\n\\#\\ \\(ensures\\ a\\ clean\\ slate\\ with\\ no\\ other\\ files\\ present\\)\\\\nmkdir\\ tmp\\\\ncd\\ tmp\\\\n\\\\n\\#\\ Download\\ using\\ aria2c\\ with\\ 8\\ connections\\\\n/usr/local/bin/aria2c\\ -x8\\ -j8\\ -s8\\ \\\\\\\"\\$url\\\\\\\"\\\\n\\\\n\\#\\ Rename\\ if\\ necessary\\ \\(note\\ that\\ we\\ are\\ using\\ \\*\\ since\\\\n\\#\\ we\\ don\\'t\\ know\\ what\\ the\\ downloaded\\ filename\\ is,\\ but\\\\n\\#\\ it\\ should\\ work\\ since\\ there\\ should\\ be\\ exactly\\ one\\\\n\\#\\ file\\ downloaded\\ inside\\ this\\ temp\\ folder\\)\\\\nif\\ \\[\\[\\ \\\\\\\"\\$new_name\\\\\\\"\\ \\!\\=\\ \\\\\\\"\\\\\\\"\\ \\]\\]\\;\\ then\\\\n\\ \\ mv\\ \\*\\ \\\\\\\"\\$new_name\\\\\\\"\\\\nfi\\\\n\\\\n\\#\\ Emit\\ the\\ output\\\\nemit\\ fetched_file\\ \\*\\\"\\} | python -c 'import sys,json; print json.load(sys.stdin)[\"code\"]' \u003e /script.sh"]

# Create directory /work and set it to $HOME and CWD
RUN mkdir -p /work
ENV HOME="/work"
WORKDIR /work

# Set entry point to container
ENTRYPOINT ["/usr/bin/run"]

VOLUME /data
VOLUME /work