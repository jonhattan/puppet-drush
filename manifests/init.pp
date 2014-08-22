# == Class: drush
#
# Installs drush system-wide with composer and prepares a working environment.
#
# === Parameters
#
# [*versions*]
#   Array of versions of drush to install.
#   Valid values are '5', '6', and 'master'.
#
# [*default_version*]
#   String with the drush version considered the main version.
#
# [*bash_integration*]
#   Boolean indicating whether to enable drush bash facilities. It configures
#   bash to source drush's example.bashrc for any session.
#
# [*bash_autocompletion*]
#   Boolean indicating whether to enable bash autocompletion for drush commands.
#   Doesn't take effect if bash_integration is true.
#
# [*extensions*]
#   List of drush extensions to download.
#
# [*aliases*]
#   Hash of aliases to make available system wide.
#
class drush(
  $versions            = ['6',],
  $default_version     = '6',
  $bash_integration    = false,
  $bash_autocompletion = true,
  $extensions          = [],
  $aliases             = {},
  $composer_path       = '/usr/local/bin/composer',
) {

  validate_array($versions)
  validate_string($default_version)
  validate_bool($bash_integration)
  validate_bool($bash_autocompletion)
  validate_array($extensions)
  validate_hash($aliases)

  # Parent directory of all drush installations.
  file { '/opt/drush':
    ensure => directory,
  }

  # Drush directories.
  file { ['/etc/drush', '/usr/share/drush', '/usr/share/drush/commands']:
    ensure => directory,
  }

  # Install drush versions.
  # Could be improved with future parser's each() function.
  if '6' in $versions {
    drush::install { 'drush-6':
      version => '6.*',
    }
  }
  if 'master' in $versions {
    drush::install { 'drush-master':
      version => 'dev-master',
    }
  }

  # Symlink for drush default version.
  $def_v = split($default_version, '[.]')
  file { '/usr/local/bin/drush':
    ensure  => link,
    target  => "/usr/local/bin/drush${def_v}",
  }

  # Clear drush cache on demand.
  exec { 'drush cc drush':
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    refreshonly => true,
    require     => File["/usr/local/bin/drush"],
  }

  # Bash integration based on the default version.
  if $bash_integration {
    file { '/etc/profile.d/drushrc':
      ensure => link,
      target => "/opt/drush/${def_v}/vendor/drush/drush/examples/example.bashrc",
    }
  }
  elsif $bash_autocompletion {
    file { '/etc/bash_completion.d/drush':
      ensure => link,
      target => "/opt/drush/${def_v}/vendor/drush/drush/drush.complete.sh",
    }
  }

  drush::extension{ $extensions: }
  create_resources(drush::alias, $aliases)
}

