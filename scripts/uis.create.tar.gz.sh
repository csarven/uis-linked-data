#!/bin/bash

. ./uis.config.sh

cd "$data"
tar -cvzf meta.tar.gz *.Structure.rdf uis.*

tar -cvzf data.tar.gz *.rdf --exclude='*.Structure.rdf' --exclude='uis.*'

