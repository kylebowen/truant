# frozen_string_literal: true

require "open3"

require_relative "../command"

module Truant
  module Commands
    class Purge < Truant::Command
      def initialize(pathname, options)
        @pathname = Pathname.new("#{Config.config.fetch(:base_dir)}#{pathname}")
        @command = "rm"
        @args = ["-f", @pathname.to_s]
        @options = options
      end

      no_commands do
        def execute
          # check if file exists already
          if !@pathname.file?
            # it doesn't exist - raise an error
            raise Truant::CLI::Error, "Huh, nothing here..."
          else
            puts "purging... #{@pathname}"
            # it does exist - delete it
            Open3.popen3(@command, *@args) { |stdin, stdout, stderr, wait_thr|
              tattle(wait_thr.pid)
            }
          end
        end

        def tattle(pid)
          # process_name = spy(pid, :comm=)
          # command_line = spy(pid, :args=)
          username = spy(pid, :user=)
          start_time = spy(pid, "lstart= | date +%FT%H:%M:%S:%s%z")
          the_dirt = {
            activity: :file_delete,
            command_line: ([@command] + @args).join(" "),
            file_path: @pathname.to_s,
            pid: pid,
            process_name: @command,
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
