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
      @branch ||= git 'rev-parse --symbolic-full-name --abbrev-ref HEAD'
    end

    def diff
      @diff ||= git 'diff --shortstat --exit-code'
    end

    def dirty?
      !diff.success?
    end

    def git_pull
      git 'pull'
    end

    def git_clone
      SysCall.exec("git clone #{remote} #{full_path}")
    end

    private

    def git(command)
      SysCall.exec("git -C #{full_path} #{command}")
    end
  end

  class SysCall < String
    def self.exec(command)
      command += ' 2>&1'
      r = new `#{command}`.strip
      r.exit_code = $?
      r
    end

    attr_accessor :exit_code

    def success?
      @exit_code.success?
    end
  end
end
