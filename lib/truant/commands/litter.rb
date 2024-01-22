# frozen_string_literal: true

require "open3"

require_relative "../command"

module Truant
  module Commands
    class Litter < Truant::Command
      def initialize(pathname, options)
        @pathname = Pathname.new("#{Config.config.fetch(:base_dir)}#{pathname}")
        @pcommand = "mkdir"
        @pargs = ["-p", @pathname.dirname.to_s]
        @command = "touch"
        @args = [@pathname.to_s]
        @options = options
      end

      no_commands do
        def execute
          # check if file exists already
          if @pathname.file?
            # it does exist - raise an error
            raise Truant::CLI::Error, "Ugh, this place is already trashed..."
          else
            # it doesn't exist yet
            puts "littering... #{@pathname}"
            Open3.popen3(@pcommand, *@pargs) { |stdin, stdout, stderr, wait_thr| }
            Open3.popen3(@command, *@args) { |stdin, stdout, stderr, wait_thr|
              tattle(wait_thr.pid)
            }
          end
        end

        def tattle(pid)
          username = spy(pid, :user=)
          start_time = spy(pid, "lstart= | date +%FT%H:%M:%S:%s%z")
          # process_name = spy(pid, :comm=)
          # command_line = spy(pid, :args=)
          the_dirt = {
            activity: :file_create,
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
