# == Class: drush
#
# Installs drush system-wide with composer.
#
# Additionally it prepares a drush working environment.
#
#
# === Parameters
#
# [*extensions*]
#   List of drush extensions to download.
#
# [*aliases*]
#   Hash of aliases to make available system wide.
#
# === Examples
#
#  class { drush:
#    extensions => [ 'drush_extras', 'registry_rebuild' ],
#  }
#
# === Authors
#
# Jonathan Araña Cruz <jonhattan@faita.net>
#
# === Copyright
#
# Copyright 2014 Jonathan Araña Cruz, unless otherwise noted.
#
class drush(
  $extensions = [],
  $aliases    = {}
) {
  require ::composer

  # Create our composer global directory.
  file { '/usr/share/php/composer':
    ensure => present,
  }
  # Make sure composer's global bin directory is on the system PATH.
  file {'/etc/profile.d/composer_global_path.sh':
    content => 'PATH=/usr/share/php/composer/vendor/bin:$PATH',
  }

  # Install drush.
  composer::exec {'drush-install':
    packages    => ['drush/drush:6.*'],
    cmd         => 'require',
    cwd         => '/tmp',
    dev         => false,
    global      => true,
    working_dir => '/usr/share/php/composer',
  }

  # Create drush directories.
  file { '/etc/drush':
    ensure => directory,
  }
  file { ['/usr/share/drush', '/usr/share/drush/commands']:
    ensure => directory,
  }

  create_resources(drush::extension, $extensions)
  create_resources(drush::alias, $aliases)
}

