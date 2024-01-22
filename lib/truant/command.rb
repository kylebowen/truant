# frozen_string_literal: true

require "thor"

module Truant
  class Command < Thor
    no_commands do
      def execute(*)
        raise(
          NotImplementedError,
          "#{self.class}##{__method__} must be implemented"
        )
      end

      def spy(pid, attr)
        value = ""
        Open3.popen3("ps #{pid} -o #{attr}") { |sin, sout, serr, wait|
          while (line = sout.gets)
            value = line.chomp
          end
        }
        value
      end
    end

    # Below are examples of how to integrate TTY components

    # The external commands runner
    #
    # @see http://www.rubydoc.info/gems/tty-command
    #
    # def command(...)
    #   require "tty-command"
    #   TTY::Command.new(...)
    # end

    # The interactive prompt
    #
    # @see http://www.rubydoc.info/gems/tty-prompt
    #
    # def prompt(...)
    #   require "tty-prompt"
    #   TTY::Prompt.new(...)
    # end
  end
end
