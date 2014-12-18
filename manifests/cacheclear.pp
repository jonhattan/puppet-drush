class drush::cacheclear {

  #private()
  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} \
module and should not be directly included in the manifest.")
  }

  # Clear drush cache on demand.
  exec { 'drush-cc-drush':
    command     => "${drush::drush_exe_default} cc drush",
    require     => File[$drush::drush_exe_default],
    refreshonly => true,
  }

}

