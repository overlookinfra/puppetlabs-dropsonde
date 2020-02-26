class { 'dropsonde':
  blacklist => ['puppetfiles', 'modules'],
  update    => false,
  cachepath => '/var/cache',
  ttl       => 21,
}
