# Class: newrelic::apm
#
#   This module adds the New Relic APM Monitor to the target node.
#
# Parameters:
#
#  [*license_key*] - The license key supplied by New Relic on the instructions
#                    page for setting up a new application monitor instance.
#
#  [*app_name*]    - The name with which the application should be identified
#                    in the New Relic monitor.
#
# Examples:
#
#  class { 'newrelic::apm':
#    license_key => 'YOUR_LICENSE_KEY',
#    app_name    => 'My Application',
#  }
#
# Authors:
#
# Pier-Angelo Gaetani
#
# Copyright:
#
# Pier-Angelo Gaetani 2015
#
class newrelic::apm (
  $license_key = undef,
  $app_name    = undef,
) {
  if $license_key == undef {
    fail('The license_key parameter must be defined.')
  }

  package { 'unzip': 
    ensure => 'latest'
  }

  $base_path         = '/opt/newrelic'

  $newrelic_jar_path = '/opt/newrelic/newrelic.jar'
  $cmd_apm_package   = '/usr/bin/wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip -P /opt/'
  $test_apm_package  = '/usr/bin/test -f ${newrelic_jar_path}'

  file { $base_path:
    ensure => directory,
    
  }

  exec { 'get_apm_package':
    command => $cmd_apm_package,
    unless  => $test_apm_package,
    before  => Exec['unzip']
  }

  $cmd_apm_unzip = 'unzip /opt/newrelic-java.zip -d /opt/'

  exec { 'unzip':
    command => $cmd_apm_unzip,
    require => [Exec['get_apm_package'], Package['unzip']]
  }

  file { '/opt/newrelic/newrelic.yml':
    ensure  => file,
    content => template('templates/newrelic.yml.epp'),
    require => Exec['unzip']
  }
}