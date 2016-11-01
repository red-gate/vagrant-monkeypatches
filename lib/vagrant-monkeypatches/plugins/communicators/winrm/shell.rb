require Vagrant.source_root.join('plugins/communicators/winrm/shell')

module VagrantPlugins
  module CommunicatorWinRM
    class WinRMShell

      # TODO: Remove when 1.8.7 ships.
      # https://github.com/mitchellh/vagrant/pull/7712
      def powershell(command, &block)
        # Ensure an exit code
        command += "\r\nif ($?) { exit 0 } else { if($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }"
        session.create_executor do |executor|
          execute_with_rescue(executor.method("run_powershell_script"), command, &block)
        end
      end

      # TODO: Remove when 1.8.7 ships.
      # https://github.com/mitchellh/vagrant/pull/7712
      def cmd(command, &block)
        session.create_executor do |executor|
          execute_with_rescue(executor.method("run_cmd"), command, &block)
        end
      end
    end
  end
end
