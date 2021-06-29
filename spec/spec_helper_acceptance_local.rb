# frozen_string_literal: true

require 'puppet_litmus'
require 'yaml'

include PuppetLitmus

RSpec.configure do |c|
  c.before :suite do
    if os[:family] == 'redhat' && os[:release].to_i == 7
      run_shell('yum install cronie -y')
    end
    if os[:family] == 'debian' || os[:family] == 'ubuntu'
      run_shell('apt-get install cron -y')
    end
  end
end
