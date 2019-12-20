# frozen_string_literal: true

module Dry
  module Schema
    # A set of generic errors
    #
    # @see Result#message_set
    #
    # @api public
    class ErrorSet
      include Enumerable

      attr_reader :errors, :options

      # @api private
      def self.[](errors, options = EMPTY_HASH)
        new(errors, options)
      end

      # @api private
      def initialize(errors, options = EMPTY_HASH)
        @errors = errors
        @options = options
      end

      # @api public
      def each(&block)
        return to_enum unless block
        errors.each(&block)
      end

      # @api public
      def to_h
        errors_map
      end
      alias_method :to_hash, :to_h
      alias_method :dump, :to_h

      # @api private
      def empty?
        errors.empty?
      end

      # @api private
      def errors_map(_errors)
        raise NotImplementedError
      end
    end
  end
end
