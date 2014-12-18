define drush::alias(
  $ensure           = present,
  $group            = undef,
  $parent           = undef,
  $root             = undef,
  $uri              = undef,
  $db_url           = undef,
  $path_aliases     = undef,
  $ssh_options      = undef,
  $remote_host      = undef,
  $remote_user      = undef,
  $command_specific = undef,
) {

  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  if $root {
    validate_absolute_path($root)
  }
  if $parent {
    validate_re($parent, '^@',
    "Invalid parent alias '${parent}'. Parent aliases must start with @.")
  }
  if $command_specific {
    validate_hash($command_specific)
  }

  $aliasfile = $group ? {
    undef   => '/etc/drush/aliases.drushrc.php',
    default => "/etc/drush/${group}.aliases.drushrc.php",
  }

  if !defined(Concat[$aliasfile]) {
    concat{ $aliasfile:
      ensure => $ensure,
    }
    concat::fragment { "${aliasfile}-header":
      target  => $aliasfile,
      content => "<?php\n#MANAGED BY PUPPET!\n\n",
      order   => 0,
    }
  }

  concat::fragment { "${aliasfile}-${name}":
    target  => $aliasfile,
    content => template('drush/alias.erb'),
    order   => 1,
  }

}

