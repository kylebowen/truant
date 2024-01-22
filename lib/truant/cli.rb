require "thor"

require_relative "commands/config"

module Truant
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    def self.exit_on_failure?
      true
    end

    desc "config [SUBCOMMAND]", "Update local truant configuration settings"
    subcommand "config", Truant::Commands::Config

    desc "graffiti [PATHNAME]", "Modify [PATHNAME]"
    def graffiti(pathname)
      if options[:help]
        invoke(:help, ["graffiti"])
      else
        require_relative("commands/graffiti")
        Truant::Commands::Graffiti.new(pathname, options).execute
      end
    end

    desc "holler [URL]", "Make a GET request to [URL]"
    def holler(url = "http://www.google.com")
      if options[:help]
        invoke(:help, ["holler"])
      else
        require_relative("commands/holler")
        Truant::Commands::Holler.new(url, options).execute
      end
    end

    desc "instigate [COMMAND] [ARGS]", "Run an executable [COMMAND] with [ARGS]"
    def instigate(command, *args)
      if options[:help]
        invoke(:help, ["run"])
      else
        require_relative("commands/instigate")
        Truant::Commands::Instigate.new(command, args, options).execute
      end
    end

    desc "litter [PATHNAME]", "Create a file at '[PATHNAME]'"
    def litter(pathname = "litter.txt")
      if options[:help]
        invoke(:help, ["litter"])
      else
        require_relative("commands/litter")
        Truant::Commands::Litter.new(pathname, options).execute
      end
    end

    desc "misbehave", "Run a full suite of operations: instigate, litter, graffiti, purge, & holler"
    option :command, type: :string, aliases: :c, desc: "Command to 'instigate'", required: true
    option :args, type: :array, aliases: :a, desc: "Arguments for the 'instigate' command", required: true
    option :pathname, type: :string, aliases: :p, desc: "Pathname for file to use for 'litter', 'graffiti', & 'purge'", default: "litter.txt"
    option :url, type: :string, aliases: :u, desc: "Url to 'holler' at", default: "http://www.google.com"
    def misbehave
      if options[:help]
        invoke(:help, ["misbehave"])
      else
        require_relative("commands/misbehave")
        Truant::Commands::Misbehave.new(options).execute
      end
    end

    desc "purge [PATHNAME]", "Delete [PATHNAME]"
    def purge(pathname)
      if options[:help]
        invoke(:help, ["purge"])
      else
        require_relative("commands/purge")
        Truant::Commands::Purge.new(pathname, options).execute
      end
    end

    desc "version", "app version"
    def version
      require_relative("version")
      puts "v#{Truant::VERSION}"
    end
    map ["--version", "-v"] => :version
  end
end
