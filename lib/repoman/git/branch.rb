# frozen_string_literal: true

module Repoman
  module Git
    BRANCH_COMMAND = "rev-parse --symbolic-full-name --abbrev-ref HEAD"
    private_constant :BRANCH_COMMAND

    def self.branch(repository)
      path = repository.full_path
      raise DirectoryDoesNotExist unless Dir.exist? path

      Command.new("git -C #{path} #{BRANCH_COMMAND}")
    end
  end
end
