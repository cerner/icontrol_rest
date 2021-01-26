# frozen_string_literal: true

require 'logger'

module IcontrolRest
  module Utils
    # Module to handle all logging across this gem
    module Logging
      def self.included(klass)
        klass.extend ClassMethods
        klass.include InstanceMethods
      end

      def self.logger
        @logger ||= NullLogger.new
        @logger.progname = 'IControlRest'
        @logger
      end

      def self.use_logger(logger)
        @logger = logger
      end

      # Module for instance methods to be included when IcontrolRest::Utils::Logging is included by a class.
      module InstanceMethods
        def logger
          IcontrolRest::Utils::Logging.logger
        end
      end

      # Module for class methods to be extended when IcontrolRest::Utils::Logging is included by a class.
      module ClassMethods
        def logger
          IcontrolRest::Utils::Logging.logger
        end
      end

      # A stand-in Logger that does nothing when it is written to.
      #
      # Examples
      #
      #   null_logger = NullLogger.new(STDOUT)
      #   null_logger.info { 'This message will never get writen' }
      #
      # rubocop:disable Lint/MissingSuper
      class NullLogger < Logger
        # Intentionally do nothing
        def initialize(*_args); end

        # Intentionally do nothing
        def add(*_args, &_block); end
      end
      # rubocop:enable Lint/MissingSuper
    end
  end
end
