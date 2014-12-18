# == Defined type: drush::install
#
# Installs a Drush version with the given method.
#
# === Parameters
#
# [*version*]
#   Drush release to install. Example: 6, 6.4, master.
#
# [*autoupdate*]
#   Try and install new versions automatically. Defaults to false.
#
# [*method*]
#   Installation method. It only accepts composer at present.
#
define drush::install(
  $version,
  $autoupdate = false,
  $method     = 'composer',
) {

  # Pick major version.
  $parts = split($version, '[.]')
  $version_major = $parts[0]

  $drush        = "drush${version_major}"
  $drush_exe    = "/usr/local/bin/${drush}"
  $install_path = "${drush::install_base_path}/${version_major}"

  case $method {
    'composer': {
      drush::install::composer { $drush:
        autoupdate   => $autoupdate,
        version      => $version,
        install_path => $install_path,
        notify       => Exec["${drush}-first-run"],
      }
      file { $drush_exe:
        ensure  => link,
        target  => "${install_path}/vendor/bin/drush",
        require => Drush::Install::Composer[$drush],
      }
    }
    default: {
      fail("Unknown install method: '${method}'.")
    }
  }

  exec { "${drush}-first-run":
    command     => "${drush_exe} status",
    require     => File[$drush_exe],
    refreshonly => true,
  }

}

