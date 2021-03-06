require 'vagrant'

module VagrantPlugins
  module VagrantMonkeyPatches

    class Plugin < Vagrant.plugin('2')
      name 'monkeypatches'
      description <<-DESC
      Plugin created by Red gate to quickly monkey patch vagrant.
      DESC
    end

  end
end

require 'vagrant-monkeypatches/errors'
require 'vagrant-monkeypatches/plugins/providers/virtualbox/action'
require 'vagrant-monkeypatches/plugins/providers/virtualbox/action/network'
