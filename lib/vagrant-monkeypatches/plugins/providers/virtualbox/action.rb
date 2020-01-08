require Vagrant.source_root.join('plugins/providers/virtualbox/action')

module VagrantPlugins
  module ProviderVirtualBox
    module Action

      # monkey path to add :unknown to WaitForCommunicator's list of valid states.

      def self.action_boot
        Vagrant::Action::Builder.new.tap do |b|
          b.use CheckAccessible
          b.use CleanMachineFolder
          b.use SetName
          b.use ClearForwardedPorts
          b.use Provision
          b.use EnvSet, port_collision_repair: true
          b.use PrepareForwardedPortCollisionParams
          b.use HandleForwardedPortCollisions
          b.use PrepareNFSValidIds
          b.use SyncedFolderCleanup
          b.use SyncedFolders
          b.use PrepareNFSSettings
          b.use SetDefaultNICType
          b.use ClearNetworkInterfaces
          b.use Network
          b.use NetworkFixIPv6
          b.use ForwardPorts
          b.use SetHostname
          b.use SaneDefaults
          b.use Customize, "pre-boot"
          b.use Boot
          b.use Customize, "post-boot"
          # Add :unknown to the list of "valid" states since
          # "vboxmanage showvminfo <uuid>" can sometimes returns empty stdout
          # (with exit code 0) which causes vagrant to detect the VM state as
          # unknown and fail (Details at https://github.com/hashicorp/vagrant/issues/9023)
          # This is hopefully intermittent and the next VM state check is likely to
          # return either :starting or :running.
          b.use WaitForCommunicator, [:starting, :running, :unknown]
          b.use Customize, "post-comm"
          b.use CheckGuestAdditions
        end
      end

    end
  end
end
