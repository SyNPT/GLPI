#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
  
  echo "Run this script as root."
  exit

fi

cd /var/www/html/glpi/install/

rm -f install.php
