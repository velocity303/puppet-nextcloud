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
      mysql::db { $::nextcloud::dbname:
        user           => $::nextcloud::dbuser,
        password       => $::nextcloud::dbpass,
        sql            => $::nextcloud::db_backup_path,
        import_timeout => 900,
        grant          => ['ALL'],
      }
      file { "${::nextcloud::docroot}/nextcloud/data":
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        require => File["${::nextcloud::docroot}/nextcloud"],
        }->
        file { "${::nextcloud::docroot}/nextcloud/data/.ocdata":
          ensure  => file,
          owner   => 'apache',
          group   => 'apache',
        }
    }
    else {
      mysql::db { $::nextcloud::dbname:
        user     => $::nextcloud::dbuser,
        password => $::nextcloud::dbpass,
        grant    => ['ALL'],
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
    creates => "${::nextcloud::docroot}/nextcloud",
    require => Class['apache'],
    }->
    file{ "${::nextcloud::docroot}/nextcloud":
      owner => 'apache',
      group => 'apache',
    }
}
