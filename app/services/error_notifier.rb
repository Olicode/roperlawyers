# frozen_string_literal: true

class ErrorNotifier
  def self.call(message:)
    new(message).call
  end

  def initialize(message)
    @message = message
  end

  def call
    Sentry.capture_message(message)
  end

  private

  attr_reader :message
end