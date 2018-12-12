# frozen_string_literal: true

require 'repoman/config'
require 'repoman/repo'

module Repoman
  class Context
    attr_reader :config, :repos

    def initialize(config_path = ENV['REPOMAN_CONFIG'])
      @config = Config.new(config_path)
      @repos = repos_from_config(@config)
    end

    private

    def repos_from_config(config)
      config.repositories.map do |repo|
        Repo.new(
          name: repo['name'],
          path: repo['local'],
          root_path: config.root_path,
          remote: repo['remote']
        )
      end
    end
  end
end
