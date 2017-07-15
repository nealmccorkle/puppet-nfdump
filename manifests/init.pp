# Class: nfdump
class nfdump (
  $package_name  = $::nfdump::params::package_name,
  $user_name     = $::nfdump::params::user_name,
  $data_location = $::nfdump::params::data_location,
) inherits ::nfdump::params {

  # validate parameters here
  if $user_name == 'root' { fail('Username cannot be set to root') }

  class { '::nfdump::install': }
  -> Class['::nfdump']
}
