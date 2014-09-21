# == Defined type: drush::install::composer
#
# Installs a Drush version with Composer.
#
# === Parameters
#
# [*version*]
#   Drush version to install.
#
# [*version_string*]
#   A valid Composer version as '6', '6.4', '6.*', '6.*@dev' or 'dev-master'.
#   If undef, it will guess it from $version
#
define drush::install::composer(
  $version,
  $install_path,
) {

  #private()
  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  # If version is 'master' or a single major release number,
  # transform into something composer understands.
  $real_version = $version ? {
    /\./     => $version,
    'master' => 'dev-master',
    default  => "${version}.*",
  }

  file { $install_path:
    ensure => directory,
  }

  $base_path = dirname($install_path)
  $composer_home = "${base_path}/.composer"
  exec { "${drush::composer_path} require drush/drush:${real_version}":
    cwd         => $install_path,
    environment => ["COMPOSER_HOME=${composer_home}"],
    require     => File[$install_path],
  }

}

