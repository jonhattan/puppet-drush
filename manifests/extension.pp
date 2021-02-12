# == Define Resource Type: drush::extension
#
define drush::extension() {

  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  # Split $name at the dash to eliminate the version component.
  $parts = split($name, '-')
  $extension_name = $parts[0]

  # TODO ensure using a drush legacy version here.
  exec {"${drush::drush_exe_default} dl ${name}":
    command => "su - -c '${drush::drush_exe_default} dl ${name} && [[ -e /usr/share/drush/commands/${extension_name}/composer.json ]] && cd /usr/share/drush/commands/${extension_name} && ${drush::composer_path} install'",
    creates => "/usr/share/drush/commands/${extension_name}",
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    notify  => Class['drush::cacheclear'],
  }

}
