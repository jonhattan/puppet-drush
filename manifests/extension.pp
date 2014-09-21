define drush::extension() {

  exec {"${drush::drush_exe_default} dl ${name}":
    creates => "/usr/share/drush/commands/${name}",
    notify  => Class['cacheclear'],
  }

}

