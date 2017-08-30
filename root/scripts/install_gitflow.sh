#!/bin/sh


curl -LO https://raw.github.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh
sh gitflow-installer.sh install stable
rm gitflow-installer.sh
