#!/bin/sh

ansible-playbook -i "localhost," -c local site.yaml
