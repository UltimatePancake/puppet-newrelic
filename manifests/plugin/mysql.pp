# Class: newrelic::plugin::mysql
#
#   This module adds the New Relic MySQL monitor plugin to the target node.
#
# Parameters:
#
#  [*license_key*] - The license key supplied by New Relic on the instructions
#                    page for setting up a new database monitor instance.
#
#  [*log_level*]   - The level of information that the plugin will log.
#
#  [*db_name*]     - The database you wish to monitor.
#
#  [*db_user*]     - The database user you wish to log in as (needs to have 
#                    permissions on the database you wish to monitor).
#
#  [*db_pass*]     - The password for the user specified.
#
#  [*plugin_ver*]  - The plugin version you wish to use.
#                    See https://github.com/newrelic-platform/newrelic_mysql_java_plugin/tree/master/dist
#                    for available versions.
#
# Examples:
#
#  class { 'newrelic::plugin::mysql':
#    license_key => 'YOUR_LICENSE_KEY',
#    db_name     => 'customers'
#    db_user     => 'root'
#    db_pass     => 'your_password'
#  }
#
# Notes:
#
#  Currently only supporting RHEL 7, Ubuntu Trusty and Debian Jessie
#
# Authors:
#
# Pier-Angelo Gaetani
#
# Copyright:
#
# Pier-Angelo Gaetani 2015
#
class newrelic::plugin::mysql (
  $license_key = undef,
  $log_level   = 'info',
  $db_host     = 'localhost',
  $db_name     = undef,
  $db_user     = 'root',
  $db_pass     = undef,
  $plugin_ver  = '2.0.0',
) {
  if $license_key == undef {
    fail('The license_key parameter must be defined.')
  }

  if $db_name == undef {
    fail('The db_name parameter must be defined.')
  }

  if $db_pass == undef {
    fail('The db_pass parameter must be defined.')
  }

  $plugin_install_path = '/opt/newrelic/plugins'
  $cmd_get_plugin      = '/usr/bin/wget -O newrelic_mysql_plugin-${plugin_ver}.tar.gz https://github.com/newrelic-platform/newrelic_mysql_java_plugin/blob/master/dist/newrelic_mysql_plugin-${plugin_ver}.tar.gz?raw=true'
  $cmd_extract_tar     = '/bin/tar xvf /tmp/newrelic_mysql_plugin-${plugin_ver}.tar.gz -C ${plugin_install_path}'

  file { '/opt/newrelic':
    ensure => 'directory',
    owner  => 'newrelic',
    group  => 'wheel',
    mode   => '660',
    before => File['/opt/newrelic/plugins'],
  }
  
  file { '/opt/newrelic/plugins':
    ensure  => 'directory',
    owner   => 'newrelic',
    group   => 'wheel',
    mode    => '660',
    require => File['/opt/newrelic'],
  }

  exec { 'get_plugin':
    command => $cmd_get_plugin,
    require => File['/opt/newrelic/plugins'],
  }

  exec { 'extract_plugin':
    command => $cmd_extract_tar,
    require => Exec['get_plugin'],
  }

  file { '/opt/newrelic/plugins/newrelic_mysql_plugin-${plugin_ver}/config/newrelic.json':
    ensure  => 'present',
    owner   => 'newrelic',
    group   => 'wheel',
    content => template('puppet-newrelic/newrelic.json.erb'),
    require => Exec['extract_plugin'],
  }

  file { '/opt/newrelic/plugins/newrelic_mysql_plugin-${plugin_ver}/config/plugin.json':
    ensure  => 'present',
    owner   => 'newrelic',
    group   => 'wheel',
    content => template('puppet-newrelic/plugin.json.erb'),
    require => Exec['extract_plugin'],
  }

  # TODO: Add SysV and Systemd services
}