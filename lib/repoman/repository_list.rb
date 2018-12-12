# frozen_string_literal: true

require 'repoman/repository'

module Repoman
  class RepositoryList < Array
    def self.from_config(config)
      repos = config.repositories.map do |attrs|
        Repository.new(
          name: attrs['name'],
          path: attrs['path'],
          root_path: config.root_path,
          remote: attrs['remote']
        )
      end
      new(repos)
    end

    def initialize(repositories)
      super(repositories)
    end

    def all
      self
    end

    def local
      select { |repo| repo.exists_locally? }
    end
  end
end
