# == Class nfdump::install
#
# This class is called from nfdump for install.
#
class nfdump::install {

  if $::osfamily == 'RedHat' {
    include ::epel
    Yumrepo <| |> -> Package <| |>
  }

  package { $::nfdump::package_name:
    ensure => present,
  }

  user { $::nfdump::user_name:
    ensure => present,
    home   => "/home/${::nfdump::user_name}",
  }

  file { [ "/home/${::nfdump::user_name}", "/home/${::nfdump::user_name}/.ssh", ]:
    ensure  => directory,
    owner   => $::nfdump::user_name,
    group   => $::nfdump::user_name,
    require => User[$::nfdump::user_name],
  }

  # This is the only way to do it recursively without knowing beforehand 
  # what the data_location will be
  exec { 'create-data-folder':
    command => "mkdir -p ${::nfdump::data_location}",
    creates => $::nfdump::data_location,
    path    => '/bin:/usr/bin',
  }

  # Set permissions
  file { $::nfdump::data_location:
    ensure  => directory,
    owner   => $::nfdump::user_name,
    group   => $::nfdump::user_name,
    require => [ Exec['create-data-folder'], User[$::nfdump::user_name] ],
  }

  # We will store all of our data in 'sources'
  file { "${::nfdump::data_location}/sources":
    ensure  => directory,
    owner   => $::nfdump::user_name,
    group   => $::nfdump::user_name,
    require => [ Exec['create-data-folder'], User[$::nfdump::user_name] ],
  }
}
