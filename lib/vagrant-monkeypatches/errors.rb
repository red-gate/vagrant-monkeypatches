module Vagrant
  module Errors

    class RedGateNetworkNotFound < VagrantError
		attr_reader :network_details

		def initialize(network_details)
			@network_details = network_details
			super
		end

		def error_message
 			%{
The host network could not be found (#{@network_details}).
We do not let vagrant create Virtualbox hostonly adapters on our build infrastructure as it does not work on Windows Server Core.
The hostonly adapters are created as part of our automated provisioning and are setup using puppet instead.
As of November 2018, these configs should work without attempting to create new adapters:
	* config.vm.network "private_network", type: 'dhcp'
	* config.vm.network "private_network", ip: '129.168.254.***'
Slack #build for help if need be...
			}
		end
    end

  end
end
