# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'dropsonde base configuration' do
  after(:all) do
    remove_cron = <<-MANIFEST
    cron { 'submit Puppet telemetry report':
      ensure => absent,
    }
    MANIFEST
    # remmove the cron job
    apply_manifest(remove_cron)
    # remove the dropsonde gem
    run_shell('yes | /opt/puppetlabs/puppet/bin/gem uninstall dropsonde')
  end
  it 'runs successfully' do
    pp = 'include dropsonde'
    idempotent_apply(pp)
  end

  it 'is installed' do
    expect(run_shell('/opt/puppetlabs/puppet/bin/gem list | grep dropsonde').exit_code).to eq(0)
  end

  it 'has not config file(telemetry.yaml) for base configuration' do
    expect(run_shell('test -f /etc/puppetlabs/telemetry.yaml', expect_failures: true).exit_code).to eq(1)
  end

  it 'set the crontab' do
    expect(run_shell('crontab -l | grep /opt/puppetlabs/puppet/bin/dropsonde').exit_code).to eq(0)
  end
end
