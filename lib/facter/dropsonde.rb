Facter.add(:dropsonde) do
  confine do
    File.exist?('/opt/puppetlabs/server/apps/puppetserver/cli/apps/dropsonde')
  end

  setcode do
    cmd = '/opt/puppetlabs/bin/puppetserver dropsonde --version'
    rgx = /dropsonde version (\d\.\d\.\d)/
    {
      :bundled => true,
      :version => Facter::Core::Execution.execute(cmd, :on_fail => nil)&.match(rgx)&.captures&.first,
    }
  end
end
