class nextcloud (
  $dbuser         = 'nextcloud',
  $dbpass         = 'nextcloud',
  $dbhost         = 'localhost',
  $dbname         = 'nextcloud',
  $dbtype         = 'pgsql',
  $datadir        = '/srv/nextclouddata',
  $install_file   = 'nextcloud-9.0.52.tar.bz2',
  $install_url    = "https://download.nextcloud.com/server/releases/${install_file}",
  $fresh_install  = true,
  $db_backup_path = '/var/tmp/dbbackup_file',
  $manage_db      = true,
  $manage_apache  = true,
  $docroot        = '/var/www/html',
  $import_db      = false,
) {
  include nextcloud::install
#  $autoconfig = template('owncloud/autoconfig.php.erb')
#  exec { 'setup-autoconfig':
#    command => "echo \'${autoconfig}\' > /var/www/owncloud/config/autoconfig.php",
#    user    => 'www-data',
#    onlyif  => "test ! -f /var/www/owncloud/config/config.php",
#    path    => ['/bin','/sbin','usr/local/bin','/usr/local/sbin','/usr/bin'],
#    require => Package['owncloud'],
#    notify  => Service['apache2'],
#  }

}
