#!/bin/sh

ENDPOINT=http://rb-website-stage.prismic.io/api/documents/search

http GET \
  $ENDPOINT \
  q=='[[:d = at(document.type, "community")]]' \
  format==json \
  ref=='V-Ur-ysAACkAEy97' \
  --json \
  --print=HBhb

  # https://rb-website-stage.prismic.io/api/documents/search?ref=V-Ur-ysAACkAEy97&format=json
