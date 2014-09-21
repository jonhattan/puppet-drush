# == Class: drush
#
# Installs Drush system-wide with Composer and prepares a working environment.
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
# [*autoupdate*]
#   Try and install new versions automatically. Defaults to false.
#
# [*ensure_extra_packages*]
#  Boolean indicating wether extra system packages must be installed.
#  It defaults to false to not interfere with other modules.
#
# [*extra_packages*]
#  Array of extra packages to install if ensure_extra_packages is true.
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
# [*composer_path*]
#   Absolute path to composer executable.
#
class drush(
  $versions              = ['6',],
  $default_version       = '6',
  $autoupdate            = false,
  $ensure_extra_packages = false,
  $extra_packages        = $drush::params::extra_packages,
  $bash_integration      = false,
  $bash_autocompletion   = true,
  $extensions            = [],
  $aliases               = {},
  $composer_path         = '/usr/local/bin/composer',
) inherits drush::params {

  # Pick default major version.
  validate_string($default_version)
  $parts = split($default_version, '[.]')
  $default_version_major = $parts[0]

  validate_absolute_path($composer_path)

  $drush_exe_default = '/usr/local/bin/drush'

  class{'drush::setup': } ->
  class{'drush::config': } ~>
  class{'drush::cacheclear': } ->
  Class["drush"]

}

