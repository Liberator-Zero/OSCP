#!/bin/sh

# This one-liner setups a WebDAV server for hosting files. Think of it like the python server except WebDAV is treated more like a share
# Change the directory to wherever you want to host.

 /bin/wsgidav --host=0.0.0.0 --port=80 --auth=anonymous --root /tmp/webdav