define drush::extension($name) {
  exec {"drush dl ${name}":
    unless => "test -d /usr/share/drush/commands/${name}"
  }
}

