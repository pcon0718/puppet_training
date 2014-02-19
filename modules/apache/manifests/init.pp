class apache {
  case  $::operatingsystem {
    'centos': {
      $httpd_user = 'apache'
      $httpd_group = 'apache'
      $httpd_pkg = 'httpd'
      $httpd_svc = 'httpd'
      $httpd_conf = 'httpd.conf'
      $httpd_confdir = '/etc/httpd/conf'
      $httpd_confdir_d = '/etc/httpd/conf.d'
      $httpd_docroot =  '/var/www/html'
    }
    'ubuntu': {
      $httpd_user = 'www-data'
      $httpd_group = 'www-data'
      $httpd_pkg = 'apache2'
      $httpd_svc = 'apache2'
      $httpd_conf = 'apache2.conf'
      $httpd_confdir = '/etc/apache2'
      $httpd_confdir_d = '/etc/apache2/conf.d'
      $httpd_docroot = '/var/www'
    }
    default: {
     fail ("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
  File {
    owner => $httpd_user, 
    group => $httpd_group,
    mode  => '0644',
  }
  package { $httpd_pkg:
    ensure => present,
  }

  file { $httpd_docroot:
    ensure => directory,
  }

  file { $httpd_confdir:
    ensure => directory,
  }

  file { "${httpd_docroot}/index.html":
    ensure => present,
    content => template('apache/index.html.erb'),
  }

  file { $httpd_conf:
    ensure  => file,
    path    => "${httpd_confdir}/${httpd_conf}",
    source  => "puppet:///modules/apache/${httpd_conf}",
    owner   => 'root',
    group   => 'root',
    require => Package[$httpd_pkg],
  }

  service { $httpd_svc:
    ensure    => running,
    subscribe => File[$httpd_conf],
  }
}
