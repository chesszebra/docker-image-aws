FROM alpine

# Install Python
RUN apk add --no-cache --update \
    bash \
    ca-certificates \
    curl \
    git \
    groff \
    less \
 	openssh-client \
    python \
    python-dev \
    py-pip \
    tini \
    zip

# Install Gosu
ENV GOSU_VERSION 1.11
RUN set -eux; \
	\
	apk add --no-cache --virtual .gosu-deps \
		dpkg \
		gnupg \
	; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
# for flaky keyservers, consider https://github.com/tianon/pgp-happy-eyeballs, ala https://github.com/docker-library/php/pull/666
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
# clean up fetch dependencies
	apk del --no-network .gosu-deps; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu --version; \
	gosu nobody true

# Cleanup
RUN rm -rf /var/cache/apk/*

# Create a new user
RUN addgroup -S -g 1000 aws \
 && adduser -s /bin/bash -S -u 1000 -D -G aws aws

# Update pip
RUN pip install --upgrade pip

# Update the path with executables.
RUN mkdir -p ~/.local/bin \
 && echo "export PATH=$PATH:~/.local/bin" >> /etc/profile.d/new-path.sh

# Run as the aws user
USER aws:aws

# Install AWS tools
RUN mkdir -p ~/.aws/ \
 && pip install awscli --upgrade --user --no-cache-dir \
 && pip install awsebcli --upgrade --user --no-cache-dir

# Update the path with executables.
RUN mkdir -p ~/.local/bin \
 && echo "export PATH=$PATH:~/.local/bin" >> ~/.bash_profile

# Run as the root again
USER root:root

# Make a volume for data
VOLUME /data

# Set the working directory
WORKDIR /data

# Add the entry point script
ADD usr/local/bin/docker-image-entrypoint.sh /usr/local/bin/docker-image-entrypoint

# Make it executable
RUN chmod +x /usr/local/bin/docker-image-entrypoint

# Execute the entry point
ENTRYPOINT ["/usr/local/bin/docker-image-entrypoint"]

# Run bash by default
CMD ["bash"]
