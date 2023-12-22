# == Class: drush::params
#
# This class manages drush parameters.
#
class drush::params {
  case $facts['os']['family'] {
    'Debian': {
      $extra_packages = [
        'bzip2',
        'gzip',
        'less',
        'mysql-client',
        'rsync',
        'unzip',
        'wget',
      ]
    }
    'RedHat': {
      $extra_packages = [
        'bzip2',
        'gzip',
        'less',
        'mysql',
        'rsync',
        'unzip',
        'wget',
      ]
    }
    default: {
      fail("Unsupported operatingsystem: ${facts['os']['family']}/${facts['os']['name']}.")
    }
  }
}
