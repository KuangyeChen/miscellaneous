#!/usr/bin/env bash

sudo zpool create pool_storage /dev/sda /dev/sdc

zpool status
zpool list

sudo chown serveradmin:serveradmin /pool_storage
