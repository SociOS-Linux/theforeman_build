#!/bin/bash

red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
white=$'\e[0m'

cecho ()                     # Color-echo.
                             # Argument $1 = message
                             # Argument $2 = color
{

  message=${1}   # Defaults to default message.
  color=${2}           # Defaults to black, if not specified.

  echo $color "$message" $white

  return
}

#
# This is the simplest way to set it up, not secure or whatever, but works for an open sourced example.
#
terraform init

cecho "Starting Terraform Plan..." $magenta
terraform plan
cecho "Completed Terraform Plan..." $green

cecho "Starting Terraform Apply..." $magenta
terraform apply -auto-approve
cecho "Completed Terraform Apply..." $green