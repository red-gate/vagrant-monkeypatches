require 'vagrant/machine'

# This monkey patch of vagrant/machine can be removed when
# https://github.com/mitchellh/vagrant/pull/7190 is shipped as part of vagrant 1.8.2
module Vagrant
  class Machine

    alias_method :old_initialize, :initialize
    def initialize(*args)
      @state_mutex = Mutex.new
      old_initialize(*args)
    end

    # state uses 'machine_index.get(uuid)' which returns a locked entry
    # that must be explicitly released by the calling entity
    # use a lock to ensure that if state is accessed by multiple threads
    # they do not attempt to access the locked entity simultaneously
    alias_method :old_state, :state
    def state
      result = nil
      @state_mutex.synchronize do
        result = old_state
      end
      result
    end
  end
end
