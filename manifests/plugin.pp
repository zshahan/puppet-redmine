define redmine::plugin::rake {
  $rvm_ruby = $redmine::rvm_ruby
  if $redmine::rvm_ruby != '' {
    $rvm_prefix     = "source /usr/local/rvm/scripts/rvm; rvm use --create ${rvm_ruby} > /dev/null; "
  } else {
    $rvm_prefix     = ''
  }

  exec { $name:
    path        => "/usr/bin:/bin",
    user        => $redmine::redmine_user,
    command     => "bash -c '${rvm_prefix}cd ${redmine::app_root}/current; RAILS_ENV=production bundle exec rake ${name}'",
    refreshonly => true,
  }
}

define redmine::plugin
(
  $provider = 'git',
  $source   = undef,
  $revision = "origin/master",
  $migrate  = false,
  $rake     = [],
)
{
  $rvm_ruby = $redmine::rvm_ruby
  if $redmine::rvm_ruby != '' {
    $rvm_prefix     = "source /usr/local/rvm/scripts/rvm; rvm use --create ${rvm_ruby} > /dev/null; "
  } else {
    $rvm_prefix     = ''
  }

  $app_root     = $redmine::app_root
  $redmine_user = $redmine::redmine_user
  $redmine_dir  = "${redmine::app_root}/current"
  $plugins_dir  = "${redmine_dir}/plugins"
  $plugin_dir   = "${redmine_dir}/plugins/${name}"

  vcsrepo { $plugin_dir:
    ensure   => present,
    provider => $provider,
    source   => $source,
    revision => $revision,
    user     => $redmine_user,
    require  => [File[$app_root], Exec["redmine-configure"]],
    notify   => Service['redmine'],
  }

  ->

  exec { "bundle-${name}-plugin":
    path    => '/bin:/usr/bin',
    command => "bash -c '${rvm_prefix}cd ${app_root}/current; bundle --without ${redmine::without_gems}'",
    unless  => "bash -c '${rvm_prefix}cd ${app_root}/current; bundle check'",
    notify  => Service['redmine'],
    user    => $redmine_user,
    group   => $redmine_user,
    timeout => 600,
  }

  ->

  exec { "migrate-${name}-plugin":
    path        => "/usr/bin:/bin",
    user        => $redmine_user,
    command     => $migrate ? {
      true  => "bash -c '${rvm_prefix}cd ${redmine_dir}; RAILS_ENV=production bundle exec rake db:migrate'",
      false => "/bin/true",
    },
    refreshonly => true,
    notify      => Service['redmine'],
  }

  ->

  redmine::plugin::rake { $rake:
    subscribe => Vcsrepo[$plugin_dir],
    require   => [Exec["migrate-${name}-plugin"], Vcsrepo[$plugin_dir]],
  }
}
