# frozen_string_literal: true

require 'dry/initializer'

require 'dry/schema/constants'
require 'dry/schema/config'
require 'dry/schema/result'
require 'dry/schema/messages'
require 'dry/schema/message_compiler'
require 'dry/schema/ast_error_compiler'

module Dry
  module Schema
    # Applies rules defined within the DSL
    #
    # @api private
    class RuleApplier
      extend Dry::Initializer

      # @api private
      param :rules

      # @api private
      option :config, default: proc { Config.new }

      # @api private
      option :message_compiler, default: (proc do
        if config.errors == :messages
          MessageCompiler.new(Messages.setup(config))
        elsif config.errors == :ast
          AstErrorCompiler.new
        end
      end)

      # @api private
      def call(input)
        results = EMPTY_ARRAY.dup

        rules.each do |name, rule|
          next if input.error?(name)
          result = rule.(input)
          results << result if result.failure?
        end

        input.concat(results)
      end

      # @api private
      def to_ast
        if config.namespace
          [:namespace, [config.namespace, [:set, rules.values.map(&:to_ast)]]]
        else
          [:set, rules.values.map(&:to_ast)]
        end
      end
    end
  end
end
