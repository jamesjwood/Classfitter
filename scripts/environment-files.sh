#!/bin/sh -xe

: "${FULL_VERSION_FILE:?There must be a FULL_VERSION_FILE environment variable set}"
: "${VERSION_FILE:?There must be a VERSION_FILE environment variable set}"
: "${PAYLOAD_FILE:?There must be a PAYLOAD_FILE environment variable set}"
: "${payload:?There must be a payload environment variable set}"
: "${FIREBASE_SERVICE_FILE:?There must be a FIREBASE_SERVICE_FILE environment variable set}"
: "${FIREBASE_SYMBOL_SERVICE_JSON:?There must be a FIREBASE_SYMBOL_SERVICE_JSON environment variable set}"
: "${FIREBASE_ANALYTICS_FILE:?There must be a FIREBASE_ANALYTICS_FILE environment variable set}"
: "${FIREBASE_ANALYTICS_PLIST:?There must be a FIREBASE_ANALYTICS_PLIST environment variable set}"
: "${ENVIRONMENT_DIRECTORY:?There must be a ENVIRONMENT_DIRECTORY environment variable set}"
: "${BIN_DIRECTORY:?There must be a BIN_DIRECTORY environment variable set}"
: "${PROVISIONING_PROFILE_FILENAME:?There must be a PROVISIONING_PROFILE_FILENAME environment variable set}"



. $HOME/.nvm/nvm.sh
source "$HOME/.rvm/scripts/rvm"
alias cftool="${WORKSPACE}/node_modules/classfitter-tools/lib/index.js"

mkdir -p $ENVIRONMENT_DIRECTORY
rm -rf $BIN_DIRECTORY
mkdir -p $BIN_DIRECTORY


#GETTING VERSION INFORMATION FROM payload
touch $PAYLOAD_FILE
echo ${payload} > ${PAYLOAD_FILE}
VERSION_NUMBER=$(cftool getVersionFromPayload ${PAYLOAD_FILE})
echo "${VERSION_NUMBER}" > ${VERSION_FILE}
echo "v${VERSION_NUMBER}+${BUILD_NUMBER}" > ${FULL_VERSION_FILE}

rsync -av --progress * $ENVIRONMENT_DIRECTORY/ --exclude 'bin' --exclude 'env'

#FIREBASE CRASH
rm -rf FIREBASE_SERVICE_FILE
echo "cp ${FIREBASE_SYMBOL_SERVICE_JSON} ${FIREBASE_SERVICE_FILE}"
cp $FIREBASE_SYMBOL_SERVICE_JSON $FIREBASE_SERVICE_FILE
#FIREBASE ANALYTICS
echo "rm -rf ${FIREBASE_ANALYTICS_FILE}"
rm -rf $FIREBASE_ANALYTICS_FILE
cp $FIREBASE_ANALYTICS_PLIST $FIREBASE_ANALYTICS_FILE

#/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${BUNDLE_IDENTIFIER}" ${IOS_APP_DIRECTORY}/Info.plist