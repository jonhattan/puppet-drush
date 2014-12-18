class drush::config {

  #private()
  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} \
module and should not be directly included in the manifest.")
  }

  # Bash integration and autocompletion based on the default version.
  validate_bool($drush::bash_integration,
                $drush::bash_autocompletion
  )
  if $drush::bash_integration {
    file { '/etc/profile.d/drushrc':
      ensure => link,
      target => "/opt/drush/${drush::default_version_major}/vendor/drush/drush/examples/example.bashrc",
    }
  }
  elsif $drush::bash_autocompletion {
    file { '/etc/bash_completion.d/drush':
      ensure => link,
      target => "/opt/drush/${drush::default_version_major}/vendor/drush/drush/drush.complete.sh",
    }
  }

  # Create aliases.
  validate_hash($drush::aliases)
  create_resources(drush::alias, $drush::aliases)

  # Install extensions.
  validate_array($drush::extensions)
  drush::extension{ $drush::extensions: }

}

