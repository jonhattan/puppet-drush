class drush::setup {

  #private()
  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  # Install extra packages.
  validate_bool($drush::ensure_extra_packages)
  if $drush::ensure_extra_packages {
    validate_array($drush::extra_packages)
    package { $drush::extra_packages:
      ensure => installed,
    }
  }

  # Parent directory of any drush installations.
  file { '/opt/drush':
    ensure => directory,
  }

  # Drush directories.
  file { ['/etc/drush', '/usr/share/drush', '/usr/share/drush/commands']:
    ensure => directory,
  }

  # Symlink to drush default version.
  file { $drush::drush_exe_default:
    ensure  => link,
    target  => "/usr/local/bin/drush${drush::default_version_major}",
  }

  # Install drush versions. It could be improved with future parser's each().
  # or building a hash like {'6' => {'version' => '6'}, 'master' => {'version' => 'master'}}
  validate_array($drush::versions)
  $versions = parseyaml(template('drush/install-versions-hash.erb'))
  $defaults = {
    autoupdate => $drush::autoupdate,
    method     => 'composer'
  }
  create_resources('drush::install', $versions, $defaults)

}

