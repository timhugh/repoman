# frozen_string_literal: true

module Repoman
  class Repo
    attr_reader :name, :path, :remote

    def initialize(name:, path:, remote:)
      @name = name
      @path = path
      @remote = remote
    end

    def git_status
      `git -C #{path} status 2>&1`
    end

    def git_pull
      `git -C #{path} pull 2>&1`
    end

    def git_clone
      `git clone #{remote} #{path} 2>&1`
    end
  end
end
