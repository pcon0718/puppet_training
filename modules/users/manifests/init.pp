class users {
  user { 'fundamentals':
    ensure => present,
    groups => 'staff',
    shell  => '/bin/zsh',
  }


 group { 'staff':
  ensure => present,
 }
}
