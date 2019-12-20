# frozen_string_literal: true

require 'dry/schema/error_set'

module Dry
  module Schema
    # A set of error messages used to generate human-readable errors
    #
    # @see Result#message_set
    #
    # @api public
    class MessageSet < ErrorSet
      include Enumerable

      attr_reader :errors, :placeholders, :options

      private

      # @api private
      def errors_map(errors = self.errors)
        initialize_placeholders!
        errors.group_by(&:path).reduce(placeholders) do |hash, (path, msgs)|
          node = path.reduce(hash) { |a, e| a[e] }

          msgs.each do |msg|
            node << msg
          end

          node.map!(&:to_s)

          hash
        end
      end

      # @api private
      def paths
        @paths ||= errors.map(&:path).uniq
      end

      # @api private
      def initialize_placeholders!
        @placeholders ||= errors.map(&:path).uniq.reduce({}) do |hash, path|
          curr_idx = 0
          last_idx = path.size - 1
          node = hash

          while curr_idx <= last_idx do
            key = path[curr_idx]
            node = (node[key] || node[key] = curr_idx < last_idx ? {} : [])
            curr_idx += 1
          end

          hash
        end
      end
    end
  end
end
