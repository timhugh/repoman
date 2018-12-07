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
      %x{git -C #{path} status 2>&1}
    end

    def git_pull
      %x{git -C #{path} pull 2>&1}
    end

    def git_clone
      %x{git clone #{remote} #{path} 2>&1}
    end
  end
end
