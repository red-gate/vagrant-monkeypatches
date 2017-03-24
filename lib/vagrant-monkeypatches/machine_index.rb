require 'timeout'
require 'vagrant/machine_index'
require 'log4r'
require 'win32/mutex'

# Monkey patching Vagrant::MachineIndex
# This is to work around some weird issues/deadlocks we're
# seeing on windows when calling flock.
module Vagrant

  class MachineIndex

    MUTEXNAME = 'vagrant-machineindex'

    alias_method :old_initialize, :initialize
    def initialize(*args)
      @logger = Log4r::Logger.new("vagrant::machine_index")
      @win_mutex = Win32::Mutex.open(MUTEXNAME)
      old_initialize(*args)
    end

    protected

    def with_index_lock
      @logger.warn("Waiting for mutex #{MUTEXNAME}")
      @win_mutex.wait
      begin
        @logger.warn("Got mutex #{MUTEXNAME}")
        yield
      ensure
        @logger.warn("Releasing mutex #{MUTEXNAME}")
        @win_mutex.release
      end
    end
  end
end
