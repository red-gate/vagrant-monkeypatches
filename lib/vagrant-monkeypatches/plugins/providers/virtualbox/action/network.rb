require Vagrant.source_root.join('plugins/providers/virtualbox/action/network')

module VagrantPlugins
  module ProviderVirtualBox
    module Action
      # This middleware class sets up all networking for the VirtualBox
      # instance. This includes host only networks, bridged networking,
      # forwarded ports, etc.
      #
      # This handles all the `config.vm.network` configurations.
      class Network

        def hostonly_adapter(config)

          @logger.info("Searching for matching hostonly network: #{config[:ip]}")

          # Try to get a matching hostonly adapter up to 3 times.
          # (suspect vboxmanage list hostonlifs might sometimes return nothing even though the network adapter does exist.)
          interface = hostonly_find_matching_network(config)
          interface = hostonly_find_matching_network(config) if !interface
          interface = hostonly_find_matching_network(config) if !interface

          if !interface
            # It is an error if a specific host only network name was specified
            # but the network wasn't found.
            if config[:name]
              raise Vagrant::Errors::NetworkNotFound, name: config[:name]
            end

            raise Vagrant::Errors::RedGateNetworkNotFound.new("type: #{config[:type]}, ip: #{config[:ip]}")
          end

          if config[:type] == :dhcp
            create_dhcp_server_if_necessary(interface, config)
          end

          return {
            adapter:     config[:adapter],
            hostonly:    interface[:name],
            mac_address: config[:mac],
            nic_type:    config[:nic_type],
            type:        :hostonly
          }
        end
      end
    end
  end
end
