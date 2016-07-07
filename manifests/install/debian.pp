class nextcloud::install::debian {
  include apt
  apt::source { 'owncloud':
    comment  => 'This is the Owncloud Debian Repository',
    location => 'http://download.owncloud.org/download/repositories/stable/Debian_8.0',
    release  => ' ',
    repos    => '/',
    key      => {
      'id'     => 'BCECA90325B072AB1245F739AB7C32C35180350A',
      'source' => 'https://download.owncloud.org/download/repositories/stable/Debian_8.0/Release.key',
    },
    include  => {
      'deb' => true,
    },
  }
  package { 'owncloud':
    ensure  => present,
    require => Apt::Source['owncloud'],
  }
  package { 'php-apc':
    ensure  => present,
    require => Package['owncloud'],
    notify  => Service['apache2'],
  }
}
