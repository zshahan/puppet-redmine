# Puppet-redmine

Puppet redmine installs redmine with puma::app (this one you have to
install yourself).

## Basic Usage

```
  class { 'redmine':
    app_root             = '/srv/redmine',
    redmine_source       = 'https://github.com/redmine/redmine.git',
    redmine_revision     = 'origin/2.3-stable',
    redmine_user         = 'deployment',
    db_adapter           = 'pgsql',
    db_name              = 'redminedb',
    db_user              = 'redminedbu',
    db_password          = 'changeme',
    db_host              = 'localhost',
    db_port              = '3306',
    rvm_ruby             = '1.9.3@redmine',
  }
```

## Redmine Plugin

```
  redmine::plugin { 'redmine_backlogs':
    source   => 'git://github.com/backlogs/redmine_backlogs.git',
    revision => 'v1.0.6',
    migrate  => true,
    rake     => ['redmine:backlogs:install story_trackers=Bug,Feature,Support task_tracker=Task corruptiontest=true labels=true'],
  }
```

### Parameters

* app\_root: Target directory for puma::app resource. (default: '/srv/redmine')
* redmine\_source: Source repository. (default: 'https://github.com/redmine/redmine.git')
* redmine\_revision: Branch or tag to be deployed. (default: 'origin/2.3-stable')
* redmine\_user: Owner of all redmine data and the user to run it under. (default: 'deployment')
* db\_adapter: Database adapter. (default: 'mysql')
* db\_name: Database name. (default: 'redminedb')
* db\_user: Database username. (default: 'redminedbu')
* db\_password: Database password. (default: 'changeme')
* db\_host: Database host. (default: 'localhost')
* db\_port: Database port. (default: '3306')
* mail\_delivery\_method: Redmine mail delivery method. (default: 'sendmail')
* mail\_starttls: Redmine use starttls. (default: undefined)
* mail\_address: Mail server address. (default: undefined)
* mail\_port: Mail server port. (default: undefined)
* mail\_domain: Mail server domain. (default: undefined)
* mail\_authentication: Mail server authentication. (default: undefined)
* mail\_username: Mail server username.  (default: undefined)
* mail\_password: Mail server password. (default: undefined)
* rvm\_ruby: Which ruby to use, per default RVM is not used. (default: '')

## Dependencys

[puppetlabs/vcsrepo](https://github.com/puppetlabs/puppetlabs-vcsrepo) >= 0.2.0

## Contribute

Want to help - send a pull request.

## License

This file is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3, or (at your option) any
later version.

This file is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING. If not, write to the Free
Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
