# Drush

Installs [Drush](http://www.drush.org/) and allows to define global
configuration, aliases and extensions.

Installation is performed with [Composer](https://getcomposer.org/). It is done
system-wide in `/usr/share/php/composer` and a symlink to Drush executable is
placed in `/usr/local/bin`.

It doesn't goes crazy to provide a freaking drush commands interface.


# Example usage

* Hieradata:

```yaml
classes :
  - drush

drush::extensions :
  - drush_extras
  - registry_rebuild
```

* Manifest:

```
hiera_include('classes')

drush::extension{'drush_deploy':}
```

# License

MIT

# Author Information

Jonathan Araña Cruz - SB IT Media, S.L.

