# frozen_string_literal: true

require 'thor'
require 'colorize'
require 'tty-table'

require 'repoman/git'

require 'repoman/version'
require 'repoman/config'
require 'repoman/repository_list'

module Repoman
  class CLI < Thor
    class_option :config, type: :string

    desc 'open', 'opens an editor in the specified repository'
    def open(repo_name)
      repo = repositories.find { |r| r.name == repo_name }

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
        puts 'open editor or terminal [E/t]?'
      elsif repo.branch != 'master'
        puts "#{repo.name} is currently on #{repo.branch}"
        puts 'status: clean'
        puts 'switch to master [y/N]?'
      end
    end

    desc 'status', 'prints git status of all repos'
    method_option :skip_clean, type: :boolean, default: true
    method_option :skip_uncloned, type: :boolean, default: true
    def status
      table = TTY::Table.new do |t|
        repositories.each.with_concurrency do |repo|
          unless repo.exists_locally?
            raise "#{repo.path} does not exist locally!" unless options[:skip_uncloned]

            next
          end

          next if options[:skip_clean] && !repo.dirty?

          t << [repo.path, colorize_branch(repo.branch.to_s), repo.diff]
        end
      end
      puts table.render(:basic, padding: [0, 4, 0, 0])
    end

    desc 'branch', 'prints current branch of all repos'
    method_option :hide_master, type: :boolean, default: false
    method_option :skip_uncloned, type: :boolean, default: true
    def branch
      table = TTY::Table.new do |t|
        repositories.each.with_concurrency do |repo|
          branch = Git.branch(repo)
          next if branch == 'master' && options[:hide_master]
          t << [repo.path, colorize_branch(branch.to_s)]
        rescue Git::DirectoryDoesNotExist => exception
          raise unless options[:skip_uncloned]
        end
      end
      puts table.render(:basic, padding: [0, 4, 0, 0])
    end

    desc 'pull', 'pulls latest commits for all repos'
    def pull
      repositories.each.with_concurrency do |repo|
        puts "#{repo.path} - #{repo.git_pull}"
      end
    end

    desc 'clone', 'clones any repos that don\'t already exist'
    method_option :quiet, type: :boolean, default: true
    def clone
      repositories.each.with_concurrency do |repo|
        Git.clone(repo)
        puts "Cloned #{repo.path}"
      rescue Git::DirectoryExists
        puts "Skip #{repo.path}" unless options[:quiet]
      end
    end

    desc 'version', 'prints the version'
    def version
      puts Repoman::VERSION
    end

    private

    def colorize_branch(branch)
      branch == 'master' ? branch.green : branch.red
    end

    def repositories
      return @repositories if @repositories
      raise 'Must specify a config file!' unless (path = options[:config] || ENV['REPOMAN_CONFIG'])

      config = Config.new(path)
      @repositories = RepositoryList.from_config(config)
    end
  end
end
