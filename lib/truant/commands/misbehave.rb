# frozen_string_literal: true

require_relative "../command"
require_relative "instigate"
require_relative "litter"
require_relative "graffiti"
require_relative "purge"
require_relative "holler"

module Truant
  module Commands
    class Misbehave < Truant::Command
      def initialize(options)
        @options = options
        @command = options[:command]
        @args = options[:args]
        @pathname = options[:pathname]
        @url = options[:url]
      end

      no_commands do
        def execute
          puts "start misbehaving..."
          Litter.new(@pathname, @options).execute
          Instigate.new(@command, @args, @options).execute
          Holler.new(@url, @options).execute
          Graffiti.new(@pathname, @options).execute
          Purge.new(@pathname, @options).execute
          puts "stop misbehaving..."
        end
      end
    end
  end
end
