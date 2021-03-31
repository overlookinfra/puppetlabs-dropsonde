class { 'dropsonde':
  disable   => ['puppetfiles', 'modules'],
  update    => false,
  cachepath => '/var/cache',
  ttl       => 21,
}
