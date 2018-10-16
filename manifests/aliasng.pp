# == Define Resource Type: drush::aliasng
#
define drush::aliasng (
  $ensure                  = present,
  $alias_name              = $name,
  $group                   = undef,
  $parent                  = undef,
  $root                    = undef,
  $uri                     = undef,
  $db_url                  = undef,
  $path_aliases            = undef,
  $ssh_options             = undef,
  $remote_host             = undef,
  $remote_user             = undef,
  $custom_options          = undef,
  $command_specific        = undef,
  $source_command_specific = undef,
  $target_command_specific = undef,
) {

  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  if $parent {
    warning("Drush versions >= 9 doesn't support 'parent' option. Ignoring.")
  }
  if $db_url {
    warning("Drush versions >= 9 doesn't support 'db_url' option. Ignoring.")
  }
  if $source_command_specific {
    warning("Drush versions >= 9 doesn't support 'source_command_specific' option. Ignoring.")
  }
  if $target_command_specific {
    warning("Drush versions >= 9 doesn't support 'target_command_specific' option. Ignoring.")
  }

  if $root {
    validate_absolute_path($root)
  }
  if $custom_options {
    validate_hash($custom_options)
  }
  if $command_specific {
    validate_hash($command_specific)
  }

  $aliasfile = $group ? {
    undef   => "/etc/drush/sites/${alias_name}.site.yml",
    default => "/etc/drush/sites/${group}.site.yml",
  }

  if !defined(Concat[$aliasfile]) {
    concat{ $aliasfile:
      ensure => $ensure,
    }
    concat::fragment { "${aliasfile}-header":
      target  => $aliasfile,
      content => "---\n#MANAGED BY PUPPET!\n\n",
      order   => 0,
    }
  }

  concat::fragment { "${aliasfile}-${name}":
    target  => $aliasfile,
    content => template('drush/aliasng.erb'),
    order   => 1,
  }

}

