define drush::extension() {

  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  # split $name at the dash to eliminate the version component
  $name_arr = split($name, '-')
  $folder_name = $name_arr[0]

  exec {"${drush::drush_exe_default} dl ${name}":
    creates => "/usr/share/drush/commands/${folder_name}",
    notify  => Class['cacheclear'],
  }

}
