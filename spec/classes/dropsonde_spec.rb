require 'spec_helper'

describe 'dropsonde' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end

    context "on #{os} with legacy installation and enabled => false" do
      let(:facts) { os_facts }
      let(:params) { { enabled: false } }

      it { is_expected.to contain_package('dropsonde').with_ensure('latest') }
      it { is_expected.to contain_cron('submit Puppet telemetry report').with_ensure('absent') }
    end

    context "on #{os} with legacy installation and enabled => true" do
      let(:facts) { os_facts }
      let(:params) { { enabled: true } }

      it { is_expected.to contain_package('dropsonde').with_ensure('latest') }
      it { is_expected.to contain_cron('submit Puppet telemetry report').with_ensure('present') }
    end


    context "on #{os} with vendored client and enabled => false" do
      let(:facts) {
        os_facts.merge({
          :dropsonde => {:bundled => true, :version => '0.0.6'},
        })
      }
      let(:params) { { enabled: false } }

      it { is_expected.to contain_hocon_setting('submit Puppet telemetry report').with_value(false) }
    end

    context "on #{os} with vendored client and enabled => true" do
      let(:facts) {
        os_facts.merge({
          :dropsonde => {:bundled => true, :version => '0.0.6'},
        })
      }
      let(:params) { { enabled: true } }

      it { is_expected.to contain_hocon_setting('submit Puppet telemetry report').with_value(true) }
    end

  end
end
