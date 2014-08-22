define drush::extension() {
  exec {"drush dl ${name}":
    path   => ['/bin', '/usr/bin', '/usr/local/bin'],
    unless => "test -d /usr/share/drush/commands/${name}",
    notify => Exec['drush cc drush'],
  }
}

