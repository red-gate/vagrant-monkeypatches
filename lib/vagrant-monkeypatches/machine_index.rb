require "timeout"
require 'vagrant/machine_index'

# Monkey patching Vagrant::MachineIndex
module Vagrant

  class MachineIndex

    protected

    def with_index_lock
      lock_path = "#{@index_file}.lock"
      File.open(lock_path, "w+") do |f|
        # It seems that f.flock(File::LOCK_EX | File::LOCK_NB) can hung forever on our windows agents
        # even though index.lock is not even locked :(. (
        # Is it ruby ? windows ? NTFS ? Don't know, so let's add a timeout to get it to fail so that it can be tried again.
        # (which seems to workaround the problem :/)
        while(Timeout::timeout(0.5) { f.flock(File::LOCK_EX | File::LOCK_NB) } rescue false) === false do
          sleep 0.5
        end
        yield
      end
    end

  end
end
