# frozen_string_literal: true

require 'thor'
require 'colorize'

require 'repoman/version'
require 'repoman/context'

module Repoman
  class CLI < Thor
    class_option :config, type: :string

    desc 'version', 'prints the version'
    def version
      puts Repoman::VERSION
    end

    desc 'status', 'prints git status of all repos'
    method_option :skip_clean, type: :boolean, default: true
    method_option :skip_uncloned, type: :boolean, default: true
    def status
      for_all_repos do |repo|
        unless repo.exists_locally?
          raise "#{repo.name} does not exist locally!" unless options[:skip_uncloned]

          next
        end

        next if options[:skip_clean] && !repo.dirty?

        puts "#{repo.name} (#{colorize_branch(repo.branch.to_s)}) - #{repo.diff}"
      end
    end

    desc 'branch', 'prints current branch of all repos'
    method_option :hide_master, type: :boolean, default: false
    def branch
      for_all_repos do |repo|
        branch = repo.branch.to_s
        next if branch == 'master' && options[:hide_master]
        puts "#{repo.name} #{colorize_branch(branch)}"
      end
    end

    desc 'pull', 'pulls latest commits for all repos'
    def pull
      for_all_repos do |repo|
        puts "#{repo.name} - #{repo.git_pull}"
      end
    end

    desc 'clone', 'clones any repos that don\'t already exist'
    def clone
      for_all_repos do |repo|
        puts "#{repo.name} - #{repo.git_clone}"
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

    def colorize_branch(branch)
      branch == 'master' ? branch.green : branch.red
    end

    def context
      raise 'Must specify a config file!' unless (path = options[:config] || ENV['REPOMAN_CONFIG'])

      @context ||= Repoman::Context.new(path)
    end
  end
end
