define drush::extension() {

  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  exec {"${drush::drush_exe_default} dl ${name}":
    creates => "/usr/share/drush/commands/${name}",
    notify  => Class['cacheclear'],
  }

}

