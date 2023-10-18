# Drupal download URL
DRUPAL_URL="https://www.drupal.org/download-latest/tar.gz"

# Change to your web server's document root
cd /var/www/html

# Download the latest Drupal release
curl -O $DRUPAL_URL
tar -zxvf drupal-*.tar.gz
rm drupal-*.tar.gz
mv drupal-* drupal

# Create a settings.php file from the example
cp drupal/sites/default/default.settings.php drupal/sites/default/settings.php

# Create the files directory and set permissions
mkdir drupal/sites/default/files
chmod a+w drupal/sites/default/files