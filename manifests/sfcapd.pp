# Define: sfcapd
define nfdump::sfcapd(
  $ensure         = 'present',
  $source         = $title,
  $port           = 6343,
  $repeater_host  = undef,
  $repeater_port  = 6343,
  $buffer_len     = 200000,
  $extension_list = 'all'
) {
  # include our required classes
  include ::nfdump
  include ::systemd

  file { "${::nfdump::data_location}/sources/${source}":
    ensure  => directory,
    require => [ User[$::nfdump::user_name], File["${::nfdump::data_location}/sources"], ],
    owner   => $::nfdump::user_name,
    group   => $::nfdump::user_name,
  }

  file { "${::nfdump::params::defaults_location}/sfcapd-${source}":
    ensure => file,
  }

  ::systemd::unit_file { "sfcapd-${source}.service":
    content => template('nfdump/sfcapd.erb'),
    require => [
      File["${::nfdump::data_location}/sources/${source}"],
      File["${::nfdump::params::defaults_location}/sfcapd-${source}"],
      Package[$::nfdump::package_name]
    ],
    notify  => Service["sfcapd-${source}"],
  }

  service { "sfcapd-${source}":
    ensure     => running,
    require    => [ Exec['systemctl-daemon-reload'], Systemd::Unit_file["sfcapd-${source}.service"] ],
    hasrestart => true,
  }
}
