Prismic Ecto
============

An Ecto adapter for the Prismic.io CMS.

## Notes

Any request to Prismic requires 2 requests. The first to get the ref, the
second to perform the query. (sigh).

1. `http://ACCOUNT-NAME.prismic.io/api`
2. `http://ACCOUNT-NAME.prismic.io/api/documents/search?page=1&pageSize=20&ref=V-Ur-ysAACkAEy97`

The "https://micro.prismic.io/api" Prismic repo is supposed to be
stable and reliable.
