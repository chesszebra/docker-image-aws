# docker-image-aws

[![Build Status](https://travis-ci.org/chesszebra/docker-image-aws.svg?branch=master)](https://travis-ci.org/chesszebra/docker-image-aws)

A Docker image that wraps the CLI tools for AWS.

## Usage

Basic usage:

```
docker run --rm -it -v $(pwd):/data chesszebra/aws aws
```

```
docker run --rm -it -v $(pwd):/data chesszebra/aws eb
```
