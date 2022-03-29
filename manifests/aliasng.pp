# == Define Resource Type: drush::aliasng
#
define drush::aliasng (
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

