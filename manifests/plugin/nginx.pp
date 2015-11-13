# Class: newrelic::plugin::nginx
#
#   This module adds the New Relic nginx monitor plugin to the target node.
#
# Parameters:
#
#  [*license_key*]  - The license key supplied by New Relic on the instructions
#                     page for setting up a new nginx monitor instance.
#
#  [*use_latest*]   - Whether or not the package manager should download the
#                     latest or only present package.
#
#  [*data_sources*] - Data sources needed by the monitor as per documentation
#                     https://blog.newrelic.com/2014/10/17/nginx-new-relic-plugin/
#                     Each data source must be identified with a unique name.
#                     The following attributes are required:
#    [*name*]         - Indicates NGINX instance name in New Relic UI.
#    [*url*]          - Specifies full URL to the corresponding instance.
#
#                     The following attributes are optional:
#    [*http_user*]    - Can be used to set HTTP basic auth credentials in cases when the 
#    [*http_pass*]    - corresponding location is protected by an auth basic directive.
#
# Examples:
#
#  class { 'newrelic::plugin::nginx':
#    license_key => 'YOUR_LICENSE_KEY',
#    data_sources => {
#      'source1'  => {
#        name      => 'examplecom',
#        url       => 'http://example.com/status',
#        http_user => 'user',
#        http_pass => 'password',
#      },
#      'source2'  => {
#        name => 'example2com',
#        url  => 'http://example2.com/status',
#      },
#    },
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
class newrelic::plugin::nginx (
  $license_key  = undef,
  $use_latest  = true,
  $data_sources = {
    'source1' => {
      'name'      => 'examplecom',
      'url'       => 'http://example.com/status',
      'http_user' => undef,
      'http_pass' => undef,
    },
  },
) {
  if $license_key == undef {
    fail('The license_key parameter must be defined.')
  }

  if $use_latest == true {
    $package_ensure = 'latest'
  } elsif $use_latest == false {
    $package_ensure = 'present'
  } else {
    fail('The use_latest parameter must be true or false.')
  }

  if $data_sources == undef {
    fail('At least one data source must be defined.')
  }
  
  $key_path        = '/tmp/nginx_signing.key'
  $cmd_get_key     = '/usr/bin/wget http://nginx.org/keys/nginx_signing.key'
  $cmd_apt_add_key = '/usr/bin/apt-key add ${key_path}'

  case $::osfamily {
    'Debian', 'Ubuntu': {
      exec { 'get_repo_key':
        command => $cmd_get_key,
        path    => '/tmp',
        before  => Exec['add_repo_key'],
      }

      exec { 'add_repo_key':
        command => $cmd_apt_add_key,
        require => Exec['get_repo_key'],
        before  => Package['nginx-nr-agent'],
      }
    }

    'RedHat': {
      file { '/etc/yum.repos.d/nginx.repo':
        owner  => root,
        group  => root,
        source => "puppet:///modules/puppet-newrelic/files/nginx.repo"
        before  => Package['nginx-nr-agent'],
      }
    }

    default: {
      fail('The newrelic plugin module does not support ${::osfamily}.')
    }
  }

  package { 'nginx-nr-agent':
    ensure  => $package_ensure,
    before  => File['/etc/nginx-nr-agent/nginx-nr-agent.ini'],
  }

  file { '/etc/nginx-nr-agent/nginx-nr-agent.ini':
    ensure  => 'present',
    mode    => '0640',
    owner   => 'root',
    group   => 'newrelic',
    content => template('puppet-newrelic/nginx-nr-agent.ini.erb'),
    require => Package['nginx-nr-agent'],
  }

  service { 'nginx-nr-agent':
    ensure  => running,
    enable  => true,
    require => File['/etc/nginx-nr-agent/nginx-nr-agent.ini'],
  }
}