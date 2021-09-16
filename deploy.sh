#!/usr/bin/env bash

# dependencies:
# lftp
# jq
# nvm
# nodejs
# npm

# config ssh

# `bash deploy.sh i` to run the script

TARGETIP=10.111.222.189
PORT=22
USER=centos
PASSWORD=123456
codePath=/home/work/code/s90_platform
currentPath=$(pwd)

eval "$(ssh-agent)"
ssh-add ~/.ssh/phab

cd ${codePath} || echo 'cd code path failed' || exit 1
pwd

if [ "$1" = "i" ]
then
 npm install
fi

npm run pack:linux
cd "${currentPath}" || echo 'go back deploy.sh directory failed'
pwd
version=$(cat <${codePath}/package.json | jq '.version')
echo "$version"
echo "${version//\"/}"
version=${version//\"/}
filename=s90_platform-v${version}.tar.gz
echo "${filename}"

clientDir=${codePath}/dist
serverDir=/home/centos/project
pwd

echo 'uploading'
lftp -u ${USER},${PASSWORD} sftp://${TARGETIP}:${PORT} <<EOF
cd ${serverDir}/
lcd ${clientDir}
put ${filename}
by
EOF
echo 'uploaded'

echo 'ssh logging in'
ssh 189 <<EOF
cd ${serverDir}
tar -xzvf ${filename}
EOF

echo "update ${filename} finished"
