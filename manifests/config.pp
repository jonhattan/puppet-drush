# == Class: drush::config
#
# Private class.
#
class drush::config {

  #private()
  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} \
module and should not be directly included in the manifest.")
  }

  # Bash integration and autocompletion based on the default version.
  if $drush::bash_integration {
    file { '/etc/profile.d/drushrc.sh':
      ensure => link,
      target => "${drush::install_base_path}/default/examples/example.bashrc",
    }
  }
  elsif $drush::bash_autocompletion {
    file { '/etc/bash_completion.d/drush':
      ensure => link,
      target => "${drush::install_base_path}/default/drush.complete.sh",
    }
  }

  # Drush config file.
  if $drush::modern {
    $drush_modern_config = {
      drush => {
        paths => {
          alias-path => [
            '/etc/drush/sites',
          ],
          include => [
            '/usr/share/drush/commands',
          ],
        },
      },
    }
    file { '/etc/drush/drush.yml':
      ensure  => present,
      content => to_yaml($drush_modern_config),
    }
  }


  # Create aliases.
  if $drush::legacy {
    create_resources(drush::alias, $drush::aliases)
  }
  if $drush::modern {
    create_resources(drush::aliasng, $drush::aliases)
  }

  # Install extensions.
  if $drush::legacy {
    drush::extension{ $drush::extensions: }
  }

}

