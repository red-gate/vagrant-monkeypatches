require Vagrant.source_root.join('plugins/providers/virtualbox/driver/version_5_0')

module VagrantPlugins
  module ProviderVirtualBox
    module Driver
      # Driver for VirtualBox 5.0.x
      class Version_5_0

        # monkey patch clear_forwarded_ports to allow retries when vboxmanage returns VBOX_E_INVALID_OBJECT_STATE
        alias_method :old_clear_forwarded_ports, :clear_forwarded_ports
        def clear_forwarded_ports
          try = 0
          while true
            begin
              old_clear_forwarded_ports
              return
            rescue Vagrant::Errors::VBoxManageError => e
              raise if !e.extra_data[:stderr].include?("VBOX_E_INVALID_OBJECT_STATE") # VM might be locked by another vboxmanage command?
              raise if try >= 3
              try += 1
            end
          end
        end

        # monkey patch delete_unused_host_only_networks to allow retries when vboxmanage returns VBOX_E_OBJECT_NOT_FOUND
        alias_method :old_delete_unused_host_only_networks, :delete_unused_host_only_networks
        def delete_unused_host_only_networks
          try = 0
          while true
            begin
              old_delete_unused_host_only_networks
              return
            rescue Vagrant::Errors::VBoxManageError => e
              raise if !e.extra_data[:stderr].include?("VBOX_E_OBJECT_NOT_FOUND") # VM might have been deleted?
              raise if try >= 3
              try += 1
            end
          end
        end

        # monkey patch read_used_ports to allow retries when vboxmanage returns VBOX_E_OBJECT_NOT_FOUND
        alias_method :old_read_used_ports, :read_used_ports
        def read_used_ports
          try = 0
          while true
            begin
              old_read_used_ports
              return
            rescue Vagrant::Errors::VBoxManageError => e
              raise if !e.extra_data[:stderr].include?("VBOX_E_OBJECT_NOT_FOUND") # VM might have been deleted?
              raise if try >= 3
              try += 1
            end
          end
        end

      end
    end
  end
end
