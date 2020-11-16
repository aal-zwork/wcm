#!/usr/bin/env sh

export PYTHONPATH=$PYTHONPATH:/api/wcm/src 
cd /api/wcm
pipenv sync 
pipenv run python /api/wcm/src/bin/wcm-server.py --config /api/wcm.yml
