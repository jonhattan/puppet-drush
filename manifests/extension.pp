define drush::extension() {
  exec {"drush dl ${name}":
    path   => ['/usr/local/bin'],
    unless => "test -d /usr/share/drush/commands/${name}",
    notify => Exec['drush cc drush'],
  }
}

