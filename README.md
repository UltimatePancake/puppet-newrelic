#### puppet-newrelic
New Relic Server and APM Monitor

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
```
#### ---NOTES ####
Remember to add *-javaagent: /opt/newrelic/newrelic.jar* to your JVM startup environment variables.

e.g.:
  For Tomcat, edit the bin/setenv.sh file and add the above javaagent option to the CATALINA_OPTS variable:
```Shell
  export CATALINA_OPTS="${CATALINA_OPTS} -javaagent: /opt/newrelic/newrelic.jar"
```
#### ---LICENSE ####
The MIT License (MIT)

Copyright (c) 2015 Pier Gaetani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.