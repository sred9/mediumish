#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5e0f36cb3bf20d001bb00185/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e0f36cb3bf20d001bb00185 
fi
curl -s -X POST https://api.stackbit.com/project/5e0f36cb3bf20d001bb00185/webhook/build/ssgbuild > /dev/null
bundle install && bundle exec jekyll build
./inject-netlify-identity-widget.js _site
curl -s -X POST https://api.stackbit.com/project/5e0f36cb3bf20d001bb00185/webhook/build/publish > /dev/null
