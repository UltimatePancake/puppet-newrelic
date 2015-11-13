#### puppet-newrelic
New Relic Server, APM, Nginx and MySQL Monitor Puppet module

#### ---USAGE ####
```ruby
  class { 'newrelic::server':
    license_key => 'YOUR_LICENSE_KEY',
    use_latest  => true,
  }

  class { 'newrelic::apm':
    license_key => 'YOUR_LICENSE_KEY',
    app_name    => 'My Application',
  }

  class { 'newrelic::plugin::mysql':
    license_key => 'YOUR_LICENSE_KEY',
    db_name     => 'customers'
    db_user     => 'root'
    db_pass     => 'your_password'
  }

  class { 'newrelic::plugin::nginx':
    license_key => 'YOUR_LICENSE_KEY',
    data_sources => {
      'source1'  => {
        name      => 'examplecom',
        url       => 'http://example.com/status',
        http_user => 'user',
        http_pass => 'password',
      },
      'source2'  => {
        name => 'example2com',
        url  => 'http://example2.com/status',
      },
    },
  }
```
#### ---NOTES ####
Remember to add *-javaagent: /opt/newrelic/newrelic.jar* to your JVM startup environment variables.

e.g.:
  For Tomcat, edit the bin/setenv.sh file and add the above javaagent option to the CATALINA_OPTS variable:
```Shell
  export CATALINA_OPTS="${CATALINA_OPTS} -javaagent: /opt/newrelic/newrelic.jar"
```