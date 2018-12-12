# frozen_string_literal: true

module Repoman
  class Repo
    attr_reader :name, :path, :root_path, :remote

    def initialize(name:, path:, root_path:, remote:)
      @name = name
      @path = path
      @root_path = root_path
      @remote = remote
    end

    def full_path
      File.join(root_path, path)
    end

    def exists_locally?
      Dir.exist?(full_path)
    end

    def branch
      git 'rev-parse --symbolic-full-name --abbrev-ref HEAD'
    end

    def diff
      @diff ||= git 'diff --shortstat --exit-code'
    end

    def dirty?
      !diff.success?
    end

    def git_pull
      git 'pull', silent: true
    end

    def git_clone
      git 'clone', silent: true
    end

    private

    def git(command, silent: false)
      SysCall.new("git -C #{full_path} #{command}", silent: silent)
    end
  end

  class SysCall
    def initialize(command, silent: false)
      @command = command + ' 2>&1'
      @command += ' > /dev/null' if silent

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
