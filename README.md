# rt4vagrant

## About

A simple Vagrant environment for the latest version of Request Tracker.

## Usage

Installed Vagrant with a suitable hypervisor is required. To run:

    # Start
    vagrant up

    # Provision (via bash scripts)
    vagrant provision

    # With parallels
    vagrant up --provider=parallels

    # On the machine
    $ sudo start-rt


Access http://192.168.56.10 in your browser.

## Providers

This environment is configured for Parallels, VMWare and VirtualBox.

## Features

 * Newest RT (default admin credentials: `root:password`)
 * Standalone Plack Server
 * SQLite database
 * Dev- and build enviroinment included
 * Base box is ubuntu 16.04
 * Modules via CPAN installed

## Configuration

The default configuration is installed into `/vagrant/vendor/rt/etc/RT_SiteConfig.pm`.

If you need your own local configuration file for e.g. extensions and other
development tests, copy `provision/rt/RT_SiteConfig.pm` to `work/RT_SiteConfig.pm` and
provision the Vagrant box. The `work` directory is ignored by the git tree.

```
cp provision/rt/RT_SiteConfig.pm work/RT_SiteConfig.pm

vim work/RT_SiteConfig.pm

vagrant provision

vagrant ssh

sudo start-rt
```

The configuration file is located in `/vagrant/vendor/rt/etc/RT_SiteConfig.d` inside the Vagrant box
and overrides the default `/vagrant/vendor/rt/etc/RT_SiteConfig.pm` file.

## Extensions

Either use `Vagrantfile.local` to set specific synced folders, or copy
extensions into the `work` directory.

Extensions need to create a Makefile in order being installed. This requires
a specific RT install location in `/vagrant/vendor/rt`. Set the `RTHOME`
environment variable in order to avoid questions by the `perl Makefile.PL` call.

```
cd /vagrant/work/rt-extension-ticketactions

perl Makefile.PL

make
make install
```

## Database

```
sqlite3 /vagrant/vendor/rt/var/rt4

.tables

SELECT * from CustomFields;
```

## License

rt4vagrant is licensed under the terms of the GNU General Public
License Version 2, Copyright held by author.
