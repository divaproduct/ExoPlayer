#!/bin/bash


# I recommend to *NOT* just run this as a script. 
# Use the the commands as a reference but run them interactively.

# The purpose of these commands is to generate a replica of a specific exoplayer version
# with a different package name so that an app can include both this exoplayer and
# the official one (even different versions) in the same app.
# This is useful for libraries that want to depend on a specific version of exoplayer
# without breaking every time the hosting application changes/updates exoplayer version.

# 1. clone this repository --depth=1

# 2. configure the project depending on local environment: i.e.
echo "sdk.dir=$HOME/Library/Android/sdk" > local.properties

# 3. update package path (ignore errors that are printed in the console)
find . -type f -exec sed -i".bak" s/com\.google\.android\.exoplayer2/com\.deltatre\.android\.exoplayer2/g {} \;
find . -type f -name "*.bak" -delete

# 4. move package folders (ignore errors that are printed in the console)
find . -path "*/com/google" -exec bash -c "mv {}/ \`echo  {} | sed 's/com\/google/com\/deltatre/g' \`" \;

# 5. pushing artifacts to bintray on https://bintray.com/google/exoplayer
export USERNAME=davibe
export APIKEY=5836dee73f8cd3d4e7c3e46b9c3c4bff38ef4694

test -n $USERNAME || echo 'Missing username for bintray upload (USERNAME env var)'
test -n $APIKEY || echo 'Missing apikey for bintray upload (APIKEY env var)'

./gradlew build
./gradlew bintrayUpload \
    -PbintrayUser=$USERNAME \
    -PbintrayKey=$APIKEY \
    -PdryRun=false \
    -x releaseAndroidJavadocs \
    --continue

# 6. Do not commit changes, just reverte them.
git clean -fdx
git reset --hard head
# this ensures we can always start from source that closely match the official exoplayer repository

# TODOS:

- publish on github
- publish on bintray
- add thedivaproduct accounts
- add to shared accounts file
- test in TestApp
- test in integrationdemo
- test with exoplayer 2.10.8 present
- test running exoplayer 2.10.8 together