## Drush

Installs one or more versions of [Drush](http://www.drush.org/) system-wide.
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
  - drush

drush::versions   :
  - 6
  - master

drush::extensions :
  - drush_extras
  - registry_rebuild

drush::aliases    :
  foo:
    root : /var/www/foo/htdocs
    uri  : foo.local

  bar:
    root : /var/www/bar/htdocs
    uri  : bar.local
```


### Manifest

```ruby
hiera_include('classes')

drush::extension { 'drush_deploy': }
```


## License

MIT


## Author Information

Jonathan Araña Cruz - SB IT Media, S.L.

