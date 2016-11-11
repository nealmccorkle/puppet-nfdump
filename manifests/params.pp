# == Class nfdump::params
#
# This class is meant to be called from nfdump.
# It sets variables according to platform.
#
class nfdump::params {
  # This is an unprivileged user
  $user_name = 'sflow'
  $data_location = '/data/nfdump'

  case $::osfamily {
    'Debian': {
      $package_name = 'nfdump-sflow'
      $defaults_location = '/etc/default'
    }
    'RedHat', 'Amazon': {
      $package_name = 'nfdump'
      $defaults_location = '/etc/sysconfig'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
