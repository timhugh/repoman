# frozen_string_literal: true

module Repoman
  class Repository
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

    private

    def git(command)
      Command.new("git -C #{full_path} #{command}")
    end
  end
end
