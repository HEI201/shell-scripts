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

if [[ $1 =~ [a] ]]; then
    # start SSH-Agent and get its pid
    sshAgentPid=$(eval $(ssh-agent) | grep -Eo "[0-9]+")
    sshAddResult=$(ssh-add ~/.ssh/phab)
    echo "ssh agent pid: ${sshAgentPid}"
    echo "ssh file added result: ${sshAddResult}"
    echo "ssh agent start authenticated file added"
#  exit 0
fi

cd ${codePath} || echo 'cd code path failed' || exit 1
pwd

if [[ $1 =~ [i] ]]; then
    echo "run install"
    npm install
fi

if [[ $1 =~ [p] ]]; then
    echo "run pack"
    npm run pack:linux
fi

version=$(cat <${codePath}/package.json | jq '.version')
version=${version//\"/}
filename=s90_platform-v${version}.tar.gz

clientDir=${codePath}/dist
serverDir=/home/centos/project

echo 'uploading'
lftp -u ${USER},${PASSWORD} sftp://${TARGETIP}:${PORT} <<EOF
cd ${serverDir}/
lcd ${clientDir}
put ${filename}
by
EOF
echo 'uploaded'

echo 'ssh logging in'
ssh 189 /bin/bash <<EOF
cd ${serverDir}
tar -xzvf ${filename}
exit
EOF

if [[ $1 =~ [a] ]]; then
    # kill SSH-Agent
    kill -9 ${sshAgentPid}
    echo "ssh agent pid: ${sshAgentPid} killed"
fi

echo "update ${TARGETIP} ${filename} finished"
