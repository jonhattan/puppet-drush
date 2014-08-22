define drush::alias(
  $group        = undef,
  $parent       = undef,
  $docroot      = undef,
  $uri          = undef,
  $db_url       = undef,
  $path_aliases = undef,
  $ssh_options  = undef,
  $remote_host  = undef,
  $remote_user  = undef,
) {

  if $docroot {
    validate_absolute_path($docroot)
  }
  if $parent {
    validate_re($parent, '^@', "Invalid parent alias '${parent}'. Parent aliases must start with @.")
  }

  $aliasfile = $group ? {
    undef   => '/etc/drush/aliases.drushrc.php',
    default => "/etc/drush/${group}.aliases.drushrc.php",
  }

  if !defined(Concat[$aliasfile]) {
    concat{ $aliasfile: }
    concat::fragment { "$aliasfile-header":
      target  => $aliasfile,
      content => "<?php\n#MANAGED BY PUPPET!\n\n",
      order   => 0,
    }
  }

  concat::fragment { "$aliasfile-$name":
    target  => $aliasfile,
    content => template('drush/alias.erb'),
    order   => 1,
  }
}

