#! /bin/bash
echo "Mise a jour de votre Système :"
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get autoremove --purge
sudo apt-get clean
