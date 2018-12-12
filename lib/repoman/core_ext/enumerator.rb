# frozen_string_literal: true

class Enumerator
  def with_concurrency
    return enum_for(:with_concurrency) unless block_given?
    map do |*args|
      Thread.new { yield(*args) }
    end.map(&:value)
  end
end
