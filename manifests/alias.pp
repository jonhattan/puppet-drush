# == Define Resource Type: drush::alias
#
define drush::alias (
  String $ensure                          = present,
  String $alias_name                      = $name,
  Optional[String] $group                 = undef,
  Optional[String] $parent                = undef,
  Optional[Stdlib::Absolutepath] $root    = undef,
  Optional[String] $uri                   = undef,
  Optional[String] $db_url                = undef,
  Optional[Hash] $path_aliases            = undef,
  Optional[String] $ssh_options           = undef,
  Optional[String] $remote_host           = undef,
  Optional[String] $remote_user           = undef,
  Optional[Hash] $custom_options          = undef,
  Optional[Hash] $command_specific        = undef,
  Optional[Hash] $source_command_specific = undef,
  Optional[Hash] $target_command_specific = undef,
) {

  if (!defined(Class['drush'])) {
    fail('You must include class drush before declaring aliases')
  }

  if $parent {
    if $parent !~ /^@/ {
      fail("Invalid parent alias '${parent}'. Parent aliases must start with @.")
    }
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

