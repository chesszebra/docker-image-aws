#!/usr/bin/env sh

source /home/aws/.bash_profile

gosu aws "${@}"
