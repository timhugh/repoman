# frozen_string_literal: true

module Repoman
  class Command
    def initialize(command)
      command += ' 2>&1'

      @output = `#{command}`
      @exit_code = $?
    end

    def success?
      @exit_code.success?
    end

    def to_s
      @output.strip
    end
  end
end
