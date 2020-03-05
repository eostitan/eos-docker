#!/bin/bash

cd contracts/testing

shopt -s expand_aliases

/bin/bash configure.sh
/bin/bash new-bounty.sh
/bin/bash get-table.sh