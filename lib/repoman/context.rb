# frozen_string_literal: true

module Repoman
  class Context
    attr_reader :config, :repos

    def initialize(config_path)
      @config = Config.new(config_path)
      @repos = repos_from_config(@config)
    end

    private

    def repos_from_config(config)
      config.repositories.map do |repo|
        Repo.new(
          name: repo['name'],
          path: File.join(config.root_path, repo['local']),
          remote: repo['remote']
        )
      end
    end
  end
end
