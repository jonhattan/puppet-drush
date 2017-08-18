# == Define Resource Type: drush::extension
#
define drush::extension() {

  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  # Split $name at the dash to eliminate the version component.
  $parts = split($name, '-')
  $extension_name = $parts[0]

  exec {"${drush::drush_exe_default} dl ${name}":
    command => "su - -c '${drush::drush_exe_default} dl ${name}'",
    creates => "/usr/share/drush/commands/${extension_name}",
    notify  => Class['drush::cacheclear'],
  }

}
