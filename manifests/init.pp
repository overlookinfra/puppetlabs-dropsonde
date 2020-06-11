# @summary Manages the Dropsonde Puppet telementry client and cron job.
#
# In general, you'll just want to include the class, but there are a few
# settings you might care about. If you want to remove any of the computed
# metrics from the report, list them as an array in `$blacklist` and if you
# want to change the generated site ID, enter a random string as the `$seed`.
#
# @example
#   include dropsonde
class dropsonde (
  Boolean           $enabled   = true,
  Optional[Array]   $enable    = undef,
  Optional[Array]   $disable   = undef,
  Optional[String]  $cachepath = undef,
  Optional[Integer] $ttl       = undef,
  Optional[Boolean] $update    = undef,
  Optional[String]  $seed      = undef,
) {

  $config = {
    enable    => $enable,
    disable   => $disable,
    cachepath => $cachepath,
    ttl       => $ttl,
    update    => $update,
    seed      => $seed,
  }.filter |$key, $val| { $val =~ NotUndef }

  $ensure_config = $config.empty ? {
    true  => absent,
    false => file
  }

  file { '/etc/puppetlabs/telemetry.yaml':
    ensure  => $ensure_config,
    owner   => 'root',
    mode    => '0660',
    content => $config.to_yaml,
  }


  package { 'dropsonde':
    ensure   => latest,
    provider => puppet_gem,
  }


  $ensure_cron = $enabled ? {
    true  => present,
    false => absent
  }

  cron { 'submit Puppet telemetry report':
    ensure  => $ensure_cron,
    command => '/opt/puppetlabs/puppet/bin/dropsonde submit',
    user    => 'root',
    weekday => fqdn_rand(6),
    hour    => fqdn_rand(23),
    minute  => fqdn_rand(59),
  }
}
