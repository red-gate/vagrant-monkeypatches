require 'timeout'
require 'vagrant/machine_index'
require 'log4r'

# Monkey patching Vagrant::MachineIndex
module Vagrant

  class MachineIndex

    alias_method :old_initialize, :initialize
    def initialize(*args)
      @logger = Log4r::Logger.new("vagrant:machine_index")
      old_initialize(*args)
    end

    protected

    # Needed as it looks like File.open() can hang on windows when running multiple vagrant processes in paralleL !?
    # vagrant 1.8.1 and Windows Server 2012R2.
    def open_index_lock
      lock_path = "#{@index_file}.lock"
      f = nil
      while f.nil? do
        @logger.info("Opening #{lock_path}")
        f = Timeout::timeout(1) {File.open(lock_path, "w")} rescue nil
      end
      f
    end

    def with_index_lock
      lock_path = "#{@index_file}.lock"
      f = open_index_lock
      # It seems that f.flock(File::LOCK_EX | File::LOCK_NB) can sometime hung forever on our windows agents
      # even though index.lock is sometimes not even locked :(. (
      # Is it ruby ? windows ? NTFS ? Don't know, so let's add a timeout to get it to fail so that it can be tried again.
      # (which seems to workaround the problem :/)
      # Also close the file handle and reopen it in a desperate attempt to 'make it work'
      while(Timeout::timeout(0.5) { f.flock(File::LOCK_EX | File::LOCK_NB) } rescue false) === false do
          @logger.warn("Could not get a lock on #{lock_path}. Closing file handle")
          f.close
          f = nil
          @logger.warn("Could not get a lock on #{lock_path}. Sleeping for 0.5s")
          sleep 0.5
          f = open_index_lock
      end
      begin
        yield
      ensure
        @logger.info("Exiting with_index_lock and closing/unlocking #{lock_path}")
        # This should not be needed but it looks like being explicit about it might
        # improve reliability on windows?
        f.flock(File::LOCK_UN)
        f.close
      end

    end

  end
end
