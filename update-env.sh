#!/bin/bash

# Set some Vars
# opensrf_branch="remotes/origin/rel_2_1"
export opensrf_branch="master"
export opensrf_branch="remotes/origin/rel_2_2"

export opensrf_source="/usr/src/OpenSRF"

# remotes/origin/tags/rel_2_3_0 is the one true 2.3.0 code.
# openils_branch="remotes/origin/tags/rel_2_3_0"
# remotes/origin/rel_2_3 is 2.3.0 plus post-release fixes
# openils_branch="remotes/origin/rel_2_3"
export openils_branch="master"
#export openils_branch="remotes/origin/tags/rel_2_4_beta1"
#export openils_branch="user/edoceo/lp1076803a"
#export openils_branch="remotes/origin/rel_2_4"

export openils_source="/usr/src/Evergreen"

#
# Server Stuff
export PGHOST="localhost"
export PGUSER="egpg"
export PGPASSWORD="egpg"
export PGDATABASE="evergreen"

# Jabber Networks
export XMPP_PRI="private.localhost"
export XMPP_PUB="public.localhost"

export EGUSER="egsa"
export EGPASSWORD="egsa"

#
# Staff Client Stuff

# https://developer.mozilla.org/en/xul_application_packaging
# The Documentation states:
# BUILD ID should be a unique build identifier, usually date based, and should be different for each released version
# Stamp is used to make the web-root
export STAMP_ID="demo"
# VERSION should be in a format as described here:
# https://developer.mozilla.org/en/Toolkit_version_format
export VERSION=$(date +%Y.%V)

# Blank for Normal Builds - Gets Set to "debug" by update-evergeen-client for those builds
export BUILD_ID=""

#AUTOUPDATE_HOST=
