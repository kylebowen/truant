# frozen_string_literal: true

require "open3"

require_relative "../command"
require_relative "config"

module Truant
  module Commands
    class Instigate < Truant::Command
      def initialize(command, args, options)
        @command = command
        @args = args
        @options = options
      end

      no_commands do
        def execute
          puts "instigating... #{@command} #{@args.join(" ")}"

          pid = spawn(@command, *@args)
          tattle(pid)
          Process.waitpid(pid)
        end

        private

        def tattle(pid)
          command_line = spy(pid, :args=)
          process_name = spy(pid, :comm=)
          username = spy(pid, :user=)
          start_time = spy(pid, "lstart= | date +%FT%H:%M:%S:%s%z")
          the_dirt = {
            activity: :run_executable,
            command_line: command_line,
            pid: pid,
            process_name: process_name,
            start_time: start_time,
            username: username
          }
          File.open(Config.log_file, "a") { |file|
            file.write(the_dirt.to_yaml)
          }
        end
      end
    end
  end
end
