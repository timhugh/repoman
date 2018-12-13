# frozen_string_literal: true

module Repoman
  module Git
    class DirectoryExists < StandardError; end
    class DirectoryDoesNotExist < StandardError; end
  end
end

require 'repoman/git/branch'
require 'repoman/git/clone'
