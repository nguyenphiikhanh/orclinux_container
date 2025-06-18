#!/bin/bash

/usr/sbin/sshd -D

exec su - oracle -c "tail -f /dev/null"