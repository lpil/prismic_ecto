#!/bin/sh

# This repo is stable for testing, I think.
# https://micro.prismic.io/api

ENDPOINT=http://micro.prismic.io/api/documents/search

http GET \
  $ENDPOINT \
  q=='[[:d = at(document.type, "doc")]]' \
  format==json \
   ref=='V6nx_CUAAM0bW-T6' \
  --json \
  --print=HBhb



# ENDPOINT=http://rb-website-stage.prismic.io/api/documents/search

# http GET \
#   $ENDPOINT \
#   q=='[[:d = at(document.type, "community")]]' \
#   format==json \
#   ref=='V-Ur-ysAACkAEy97' \
#   --json \
#   --print=HBhb

  # https://rb-website-stage.prismic.io/api/documents/search?ref=V-Ur-ysAACkAEy97&format=json

