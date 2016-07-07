class nextcloud (
  $dbuser         = 'nextcloud',
  $dbpass         = 'nextcloud',
  $dbhost         = 'localhost',
  $dbname         = 'nextcloud',
  $dbtype         = 'mysql',
  $install_file   = 'nextcloud-9.0.52.tar.bz2',
  $install_url    = "https://download.nextcloud.com/server/releases/${install_file}",
  $fresh_install  = true,
  $db_backup_path = '/vagrant/nextcloud.sql',
  $manage_db      = true,
  $manage_apache  = true,
  $docroot        = '/var/www/html',
  $datadir        = "${docroot}/nextcloud/data",
  $import_db      = false,
) {
  include nextcloud::install
  $autoconfig = template('nextcloud/autoconfig.php.erb')
  exec { 'setup-autoconfig':
     command => "echo \'${autoconfig}\' > ${docroot}/nextcloud/config/config.php",
     user    => 'apache',
     onlyif  => "test ! -f ${docroot}/nextcloud/config/config.php",
     path    => ['/bin','/sbin','usr/local/bin','/usr/local/sbin','/usr/bin'],
     require => Class['nextcloud::install'],
     notify  => Service['httpd'],
   }

}
