# frozen_string_literal: true

require 'thor'

require 'repoman/version'
require 'repoman/context'

module Repoman
  class Git < Thor
    desc 'status', 'prints git status of all repos'
    def status
      for_all_repos do |repo|
        puts "#{repo.name} - #{repo.git_status}"
      end
    end

    desc 'pull', 'pulls latest commits for all repos'
    def pull
      for_all_repos do |repo|
        puts "#{repo.name} - #{repo.git_pull}"
      end
    end

    private

    def for_all_repos
      for_repos(context.repos) do |repo|
        yield repo
      end
    end

    def for_repos(repos)
      repos.map do |repo|
        Thread.new { yield repo }
      end.each(&:value)
    end

    def context
      raise 'Must specify a config file!' unless path = parent_options[:config] || ENV['REPOMAN_CONFIG']
      @context ||= Repoman::Context.new(path)
    end
  end

  class CLI < Thor
    class_option :config, :type => :string

    desc 'version', 'prints the version'
    def version
      puts Repoman::VERSION
    end

    desc 'git', 'git-related tasks'
    subcommand "git", Git
  end
end
