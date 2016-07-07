class nextcloud::install::redhat {

  $prerequisites = ['php', 'php-gd', 'php-mbstring', 'php-pgsql', 'php-mysqlnd', 'php-ldap', 'php-mysql', 'php-pdo', 'php-xml', 'libxml2', 'php-process', 'php-intl', 'php-pecl-memcache', 'memcached']
  package { $prerequisites:
    ensure => installed,
  }
}
