# frozen_string_literal: true

require "open3"

require_relative "../command"

module Truant
  module Commands
    class Holler < Truant::Command
      def initialize(url, options)
        @url = url
        @command = "curl"
        @args = ["-v", "-i", @url.split(" ").last]
        @options = options
      end

      no_commands do
        def execute
          puts "hollering... #{@command} #{@args.join(" ")}"

          Open3.popen3(@command, *@args) { |stdin, stdout, stderr, wait_thr|
            regexp = %r{^(?<prefix>\* Connected to) (?<destination>.*)}
            while (line = stderr.gets)
              matches = regexp.match(line)
              @destination = matches[:destination] if regexp.match?(line)
            end
            tattle(wait_thr.pid)
            stdout.gets
          }
        end

        def tattle(pid)
          username = spy(pid, :user=)
          start_time = spy(pid, "lstart= | date +%FT%H:%M:%S:%s%z")
          # process_name = spy(pid, :comm=)
          # command_line = spy(pid, :args=)
          the_dirt = {
            activity: :network_transmission,
            command_line: ([@command] + @args).join(" "),
            destination: @destination.to_s,
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
