class nextcloud::install {
  case $osfamily {
    'Debian': { include nextcloud::install::debian }
    'RedHat': { include nextcloud::install::redhat }
     default: { warning("${osfamily} is not supported") }
  }
  if $::nextcloud::manage_db {
    class { 'mysql::server':
      root_password           => 'strongpassword',
      remove_default_accounts => true,
    }
    if $::nextcloud::import_db {
      mysql::db { $::nextcloud::dbhost:
        user     => $::nextcloud::dbuser,
        password => $::nextcloud::dbpass,
        host     => $::nextcloud::dbhost,
        grant    => ['SELECT', 'UPDATE'],
      }
    }
    else {
       mysql::db { $::nextcloud::dbhost:
         user     => $::nextcloud::dbuser,
         password => $::nextcloud::dbpass,
         host     => $::nextcloud::dbhost,
         grant    => ['SELECT', 'UPDATE'],
      }
    }
  }
  if $::nextcloud::manage_apache {
    include apache
    include apache::mod::php
    include apache::mod::headers
    include apache::mod::dir
    include apache::mod::mime
    include apache::mod::rewrite
    apache::vhost { $fqdn:
      port    => 80,
      docroot => "${::nextcloud::docroot}/nextcloud",
    }
  }
  staging::deploy { $::nextcloud::install_file:
    source  => $::nextcloud::install_url,
    target  => $::nextcloud::docroot,
    require => Class['apache'],
  }->
  file{ "${::nextcloud::docroot}/nextcloud":
    owner => 'apache',
    group => 'apache',
  }
}
