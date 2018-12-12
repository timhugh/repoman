# frozen_string_literal: true

require 'thor'
require 'colorize'
require 'tty-table'

require 'repoman/context'
require 'repoman/version'

module Repoman
  class CLI < Thor
    class_option :config, type: :string

    desc 'open', 'opens an editor in the specified repository'
    def open(repo_name)
      repo = context.repos.find do |repo|
        repo.name == repo_name
      end

      if repo.nil?
        puts 'unrecognized repository!'
        exit 1
      end

      if !repo.exists_locally?
        puts "#{repo.name} does not exist locally!"
        puts "clone to #{repo.path} [Y/n]?"
      elsif repo.dirty?
        puts "#{repo.name} is currently on #{repo.branch}"
        puts "status: #{repo.diff}"
        puts "open editor or terminal [E/t]?"
      elsif repo.branch != 'master'
        puts "#{repo.name} is currently on #{repo.branch}"
        puts "status: clean"
        puts "switch to master [y/N]?"
      end
    end

    desc 'status', 'prints git status of all repos'
    method_option :skip_clean, type: :boolean, default: true
    method_option :skip_uncloned, type: :boolean, default: true
    def status
      table = TTY::Table.new do |t|
        for_all_repos do |repo|
          unless repo.exists_locally?
            raise "#{repo.path} does not exist locally!" unless options[:skip_uncloned]

            next
          end

          next if options[:skip_clean] && !repo.dirty?

          t << [repo.path, colorize_branch(repo.branch), repo.diff]
        end
      end
      puts table.render(:basic, padding: [0, 4, 0, 0])
    end

    desc 'branch', 'prints current branch of all repos'
    method_option :hide_master, type: :boolean, default: false
    method_option :skip_uncloned, type: :boolean, default: true
    def branch
      table = TTY::Table.new do |t|
        for_all_repos do |repo|
          unless repo.exists_locally?
            raise "#{repo.path} does not exist locally!" unless options[:skip_uncloned]

            next
          end

          branch = repo.branch
          next if branch == 'master' && options[:hide_master]
          t << [repo.path, colorize_branch(branch)]
        end
      end
      puts table.render(:basic, padding: [0, 4, 0, 0])
    end

    desc 'pull', 'pulls latest commits for all repos'
    def pull
      for_all_repos do |repo|
        puts "#{repo.path} - #{repo.git_pull}"
      end
    end

    desc 'clone', 'clones any repos that don\'t already exist'
    def clone
      for_all_repos do |repo|
        next if repo.exists_locally?

        puts "#{repo.path} - #{repo.git_clone}"
      end
    end

    desc 'version', 'prints the version'
    def version
      puts Repoman::VERSION
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
