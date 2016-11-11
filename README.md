# Nfdump

[![Build Status](https://travis-ci.org/sensson/puppet-nfdump.svg?branch=master)](https://travis-ci.org/sensson/puppet-nfdump) [![Puppet Forge](https://img.shields.io/puppetforge/v/sensson/nfdump.svg?maxAge=2592000?style=plastic)](https://forge.puppet.com/sensson/nfdump)

This module can be used to install nfdump and manages sfcapd processes to capture
sflow data into nfdump files. It doesn't manage nfsen or the firewall. We recommend
you to be restrictive. Only allow traffic from the devices that you trust.

## Examples

### Installation and configuration

The following example will install nfdump and sets up a single sfcapd process.

```
class { '::nfdump':
	$data_location = '/data/nfdump'
}
::nfdump::sfcapd { 'sw1':
  port => 6343,
}
```

## Reference

### Parameters

#### nfdump

We provide a number of configuration options to change particular settings
or to override our defaults when required.

##### `package_name`

Defaults to 'nfdump' on RedHat and 'nfdump-sflow' on Debian based systems.

##### `user_name`

Set the username for any sfcapd processes. Defaults to 'sflow'.

##### `data_location`

Set the location where to store nfdump data. Defaults to '/data/nfdump'.

### Defines

#### nfdump::sfcapd

This will set up an sflow capture daemon listener.

```
nfdump::sfcapd { 'device-1.location': }
```

##### `source`

This is used as an identifier to the listener. Defaults to '$title'.

##### `port`

This is the udp port the listener is available on. Defaults to '6343'.

##### `repeater_host`

Sfcapd allows you to repeat packages onto another host. Set this to an ip if you want to forward traffic. Defaults to 'undef'.

##### `repeater_port`

Sets the port your repeater is available on. Defaults to '6343'.

##### `buffer_len`

Set the buffer length. See -B in `man sfcapd`. Defaults to '200000'.

##### `extension_list`

Set the list of accepted extensions. See -T in `man sfcapd`. Defaults to 'all'.

## Limitations

This module has been tested on:

* CentOS 7
* Ubuntu 16.04

## Development

We strongly believe in the power of open source. This module is our way
of saying thanks.

This module is tested against the Ruby versions from Puppet's support
matrix. Please make sure you have a supported version of Ruby installed.

If you want to contribute please:

1. Fork the repository.
2. Run tests. It's always good to know that you can start with a clean slate.
3. Add a test for your change.
4. Make sure it passes.
5. Push to your fork and submit a pull request.

We can only accept pull requests with passing tests.

To install all of its dependencies please run:

```
bundle install --path vendor/bundle --without development
```

### Running unit tests

```
bundle exec rake test
```

### Running acceptance tests

The unit tests only verify if the code runs, not if it does exactly
what we want on a real machine. For this we use Beaker. Beaker will
start a new virtual machine (using Vagrant) and runs a series of
simple tests.

You can run Beaker tests with:

```
bundle exec rake spec_prep
BEAKER_destroy=onpass bundle exec rake beaker:centos7
BEAKER_destroy=onpass bundle exec rake beaker:ubuntu1604
```

We recommend specifying BEAKER_destroy=onpass as it will keep the
Vagrant machine running in case something fails.