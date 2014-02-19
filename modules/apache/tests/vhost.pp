include apache
apache::vhost {'pcon.puppetlabs.vm':
  docowner => root,
  docroot  => $docroot
}
