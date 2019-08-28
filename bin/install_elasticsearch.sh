#!/bin/bash

if [[ -z "$ELASTIC_SEARCH_VERSION" ]]; then
  echo "ELASTIC_SEARCH_VERSION variable not set"
else
  set -euv
  sudo dpkg -r elasticsearch
  wget "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTIC_SEARCH_VERSION}.deb"
  wget "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTIC_SEARCH_VERSION}.deb.sha512"
  shasum -a 512 -c "elasticsearch-${ELASTIC_SEARCH_VERSION}.deb.sha512"
  sudo dpkg -i --force-confnew "elasticsearch-${ELASTIC_SEARCH_VERSION}.deb"


  sudo /etc/init.d/elasticsearch stop
  sudo /etc/init.d/elasticsearch start

  sleep 10
  echo "Waiting 5 seconds for elasticsearch to start"
  until curl --silent -XGET --fail http://localhost:9200; do printf '.'; sleep 1; done
fi
