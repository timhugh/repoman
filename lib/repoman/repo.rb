# frozen_string_literal: true

module Repoman
  class Repo
    attr_reader :name, :path, :remote

    def initialize(name:, path:, remote:)
      @name = name
      @path = path
      @remote = remote
    end

    def branch
      git 'rev-parse --symbolic-full-name --abbrev-ref HEAD'
    end

    def diff(short: true)
      if short
        git 'diff --shortstat'
      else
        git 'diff'
      end
    end

    def dirty?
      !git('diff --exit-code', silent: true).success?
    end

    def git_pull
      git 'pull', silent: true
    end

    def git_clone
      git 'clone', silent: true
    end

    private

    def git(command, silent: false)
      SysCall.new("git -C #{path} #{command}", silent: silent)
    end
  end

  class SysCall
    def initialize(command, silent: false)
      @command = command
      @command += ' 2>&1 > /dev/null' if silent

      @output = `#{@command}`
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
