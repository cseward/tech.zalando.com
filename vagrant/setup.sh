#!/bin/bash

rm /etc/update-motd.d/*
cp /vagrant/vagrant/etc/update-motd.d/* /etc/update-motd.d/

apt-get remove --purge -y puppet chef
apt-get autoremove -y

if [ ! -x "/usr/bin/docker" ]; then

    # add Docker repo
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    echo 'deb https://get.docker.io/ubuntu docker main' > /etc/apt/sources.list.d/docker.list

    set +e
    until apt-get update; do
        # TODO: this should not even be necessary
        echo 'apt-get update failed, retrying..'
        rm -fr /var/lib/apt/lists/partial
        sleep 1
    done
    set -e

    # Docker
    apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confold" apparmor lxc-docker
fi

adduser vagrant docker

apt-get install -y git make nginx

cp /vagrant/vagrant/etc/nginx/sites-enabled/* /etc/nginx/sites-enabled/
service nginx restart
