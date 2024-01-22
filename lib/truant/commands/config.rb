# frozen_string_literal: true

require "tty-config"

require_relative "sub_command_base"

module Truant
  module Commands
    class Config < SubCommandBase
      attr_reader :config

      def self.config
        new.config
      end

      def self.log_file
        new.log_file
      end

      def initialize(...)
        super(...)
        @config = TTY::Config.new
        @config.filename = "config"
        @config.extname = ".yml"
        @config.append_path("#{Dir.home}/.truant/")
        if @config.exist?
          @config.read
        else
          @config.set(:base_dir, value: "#{Dir.home}/.truant/")
          @config.write(create: true)
        end
      end

      desc "logfile [FILENAME]", "Rename the file used for logging"
      option :force, type: :boolean, aliases: :f, desc: "Append logs to an existing file"
      def logfile(filename = "truant_logs.yml")
        proposed_path = "#{@config.fetch(:base_dir)}#{filename}"
        existing_path = "#{@config.fetch(:base_dir)}#{@config.fetch(:logfile)}"
        if File.file?(proposed_path) && proposed_path == existing_path
          puts existing_path
          exit(0)
        end

        # see if the new logfile already exists
        if File.exist?(proposed_path) # does the path exist?
          if !File.file?(proposed_path) # is it a directory?
            raise Truant::CLI::Error, "logfile: Dir exists"
          elsif !options[:force] # did they not want to append to existing?
            raise Truant::CLI::Error, "logfile: File exists"
          end
          # new path doesn't exist yet
        elsif File.file?(existing_path) # we do already have a log
          FileUtils.mv(existing_path, proposed_path)
        else # we don't have a log yet
          FileUtils.touch(proposed_path) # make a new file
        end

        @config.set(:logfile, value: filename)
        @config.write(force: true)
        location = "#{@config.fetch(:base_dir)}#{@config.fetch(:logfile)}"
        puts "logs will now be written to #{location}"
      end

      no_commands do
        def log_file
          "#{@config.fetch(:base_dir)}#{@config.fetch(:logfile)}"
        end
      end
    end
  end
end
