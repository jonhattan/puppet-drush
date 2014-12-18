## Drush puppet module

[![puppet forge version](https://img.shields.io/puppetforge/v/jonhattan/drush.svg)](http://forge.puppetlabs.com/jonhattan/drush) [![last tag](https://img.shields.io/github/tag/jonhattan/puppet-drush.svg)](https://github.com/jonhattan/puppet-drush/tags)

This module enables installing several versions of [Drush](http://www.drush.org/) system-wide.

At present the available installation method is via [Composer](https://getcomposer.org/).


## Quick install instructions

Find quick install instructions in the [Puppetry for Drupaleros](https://github.com/jonhattan/puppet-drush/wiki/Puppetry-for-Drupaleros)
wiki page.

These instructions are intended for people that don't have the time or the
need to learn Puppet, but wants to benefit from the facilities provided by
this Puppet module in order to install and manage several versions of Drush
system-wide.


## Features

  * Definition of Drush aliases
  * Download Drush extensions
  * Optionally install command dependencies (wget, git, gzip, rsync, ...)
  * Configures bash integration. Only autocompletion or full integration
  * Allows to choose the 'default' Drush installation

It doesn't goes crazy to provide a freaking interface to run Drush commands
from Puppet. Although it is tempting, and I don't discard that in a future,
it doesn't seem suitable in Puppet philosophy.


## What it does

Each given Drush version is installed to a directory matching its major
version under `/opt/drush/`. Also, a symlink to the executable is placed
in `/usr/local/bin/`, suffixed with its major version.

Additionally, for the default version, `/opt/drush/default` will be a symlink
to its codebase, and `/usr/local/bin/drush` will point to its executable.

For example if you choose to install Drush versions `6` and `master`, being
`6` the chosen default version, this is the final result on the filesystem:

```
d /opt/drush/master
d /opt/drush/6
l /opt/drush/default -> /opt/drush/6/vendor/drush/drush
d /opt/drush/.composer

l /usr/local/bin/drush -> /usr/local/bin/drush6
l /usr/local/bin/drush6 -> /opt/drush/6/vendor/bin/drush
l /usr/local/bin/drushmaster -> /opt/drush/master/vendor/bin/drush
```

With respect to other artifacts,

 * Aliases are installed to `/etc/drush`
 * Extensions are downloaded to `/usr/share/drush/commands`, the standard Drush
site-wide location
 * Several shell scripts may be placed in `/etc/bash_completion.d` and
`/etc/profile.d`, depending on the provided arguments to Drush class.


## Example usage

Below is an example of the supported Hiera data structure.

See [Puppetry for Drupaleros](https://github.com/jonhattan/puppet-drush/wiki/Puppetry-for-Drupaleros)
wiki page for an example of Puppet code not based on Hiera.

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

