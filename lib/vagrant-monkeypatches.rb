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

require 'vagrant-monkeypatches/machine'
require 'vagrant-monkeypatches/machine_index'
require 'vagrant-monkeypatches/plugins/providers/virtualbox/driver/version_5_0'
