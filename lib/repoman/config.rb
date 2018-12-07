# frozen_string_literal: true

require 'json'

module Repoman
  class Config
    def initialize(config_path)
      @config_path = config_path
    end

    def root_path
      config['root']
    end

    def repositories
      config['repositories']
    end

    private

    def config
      @config ||= read_from_file(@config_path)
    end

    def read_from_file(file_path)
      raw_config = File.read(file_path)
      JSON.parse(raw_config)
    end
  end
end
