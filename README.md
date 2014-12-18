## Drush puppet module

[![puppet forge version](https://img.shields.io/puppetforge/v/jonhattan/drush.svg)](http://forge.puppetlabs.com/jonhattan/drush) [![last tag](https://img.shields.io/github/tag/jonhattan/puppet-drush.svg)](https://github.com/jonhattan/puppet-drush/tags)

Installs several versions of [Drush](http://www.drush.org/) system-wide.
It is installed to `/opt/drush/DRUSH_VERSION/` and a symlink to each
executable file is placed in `/usr/local/bin/`.

Installation is done via [Composer](https://getcomposer.org/).

Features:

  * Configures bash integration
  * Download of Drush extensions
  * Definition of Drush aliases
  * Optionally install command dependencies (wget, git, gzip, rsync, ...)

It doesn't goes crazy to provide a freaking Drush commands interface
to run with Puppet.


## Quick install instructions

This instructions are indicated for people that don't have the time or the
need to learn Puppet, but wants to benefit from the facilities provided by
this repo to install and manage several versions of Drush system-wide.

Find the instructions in the [Puppetry for Drupaleros](https://github.com/jonhattan/puppet-drush/wiki/Puppetry-for-Drupaleros) wiki page.


## Example usage

### Hieradata

```yaml
classes :
  - 'drush'

drush::versions :
  - '6'
  - 'master'

drush::extensions :
  - 'drush_extras'
  - 'registry_rebuild'

drush::aliases :
  base:
    group : 'example'
    path_aliases     :
      '%dump-dir'    : '/opt/dumps'
    command_specific :
      sql-sync       :
        cache: false

  dev :
    group  : 'example'
    parent : '@base'
    root   : '/var/www/dev.example.com/htdocs'
    uri    : 'dev.example.com'

  staging :
    group       : 'example'
    parent      : '@base'
    root        : '/var/www/staging.example.com/htdocs'
    uri         : 'staging.example.com'
    remote_host : 'staging.example.com'
    remote_user : 'deploy'
    ssh_options : '-p 2203'

```


### Manifest

```ruby

# Include the declared Hiera classes and let Puppet do the magic.
hiera_include('classes')
```

## License

MIT


## Author Information

Jonathan Araña Cruz - SB IT Media, S.L.

