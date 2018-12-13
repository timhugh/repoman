# frozen_string_literal: true

require 'repoman/command'

module Repoman
  module Git
    def self.clone(repository)
      path = repository.full_path
      raise(DirectoryExists, path) if Dir.exist?(path)

      Command.new("git clone #{repository.remote} #{path}")
    end
  end
end
