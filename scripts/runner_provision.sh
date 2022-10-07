#!/bin/sh

RUNNER_URL=$1
GITHUB_URL=$2
GITHUB_TOKEN=$3
RUNNER_NAME=$4
RUNNER_DIR=$5
RUNNER_VERSION=$6
GITHUB_HASH=$7


create_runner_dir() {
    if [ ! -d $RUNNER_DIR ]; then
        mkdir -p $RUNNER_DIR && cd $RUNNER_DIR
        echo "$RUNNER_DIR directory created, accesing directory"
    else
        cd $RUNNER_DIR
        echo "$RUNNER_DIR alredy exists, accesing directory"
    fi
}

runner_download() {
    if [ ! -f $RUNNER_DIR-$RUNNER_VERSION ]; then
        curl -o $RUNNER_DIR-$RUNNER_VERSION -L $RUNNER_URL
        echo "Downloading runner file"
    else
        echo "Runner file already downloaded"
    fi
}

runner_decompress() {
    if [ ! -f ./config.sh ]; then
        echo "$GITHUB_HASH  $RUNNER_DIR-$RUNNER_VERSION" | shasum -a 256 -c
        tar xzf ./$RUNNER_DIR-$RUNNER_VERSION
        echo "Decompressed runner files"
    else
        echo "Runner files already decompressed"
    fi
}

runner_config() {
    if [ ! -f .runner ]; then
        if [ -f ./svc.sh ]; then
            sudo ./svc.sh uninstall
        fi
        ./config.sh remove
        ./config.sh --replace --url $GITHUB_URL --token $GITHUB_TOKEN --unattended --name $RUNNER_NAME --labels DevOps
        echo "Configuring runner"
    else
        sudo ./svc.sh uninstall
        rm -rf .runner
        rm -rf .credentials
        ./config.sh --replace --url $GITHUB_URL --token $GITHUB_TOKEN --unattended --name $RUNNER_NAME --labels DevOps
        echo "Runner already configured"
    fi
}

svc_install() {
    if [ ! -f ./svc.sh ]; then
        echo "No runner configured yet, svc.sh file doesn't exists"
    elif [ "$(sudo ./svc.sh status | grep "not installed")" ]; then
            sudo ./svc.sh install
    else
        echo "Services already installed"
    fi
}

create_runner_dir
runner_download
runner_decompress
runner_config
svc_install


