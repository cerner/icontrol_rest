# frozen_string_literal: true

module IcontrolRest
  # Module to handle all logging across our gem
  module Logging
    class << self
      attr_writer :logger
    end

    # Default logger to be used if logging configuration is not supplied by the user.
    class NullLogger < Logger
      def initialize(*)
        # Intentionally do nothing
      end

      def add(*)
        # Intentionally do nothing
      end
    end

    def self.logger
      @logger ||= NullLogger.new
    end

    def self.use_logger(logger)
      @logger = logger
    end

    def logger
      Logging.logger
    end
  end
end
