# frozen_string_literal: true

require 'graphql-pundit/common'

module GraphQL
  module Pundit
    # Scope methods to be included in the used Field class
    module Scope
      def self.prepended(base)
        base.include(GraphQL::Pundit::Common)
      end

      # rubocop:disable Metrics/ParameterLists
      def initialize(*args, policy: nil,
                     record: nil,
                     before_scope: nil,
                     after_scope: nil,
                     **kwargs, &block)
        @before_scope = before_scope
        @after_scope = after_scope
        @policy = policy
        @record = record
        super(*args, **kwargs, &block)
      end

      # rubocop:enable Metrics/ParameterLists

      def before_scope(scope = true)
        @before_scope = scope
      end

      def after_scope(scope = true)
        @after_scope = scope
      end

      def resolve(obj, args, ctx)
        before_scope_return = apply_scope(@before_scope, obj, args, ctx)
        field_return = super(before_scope_return, args, ctx)
        apply_scope(@after_scope, field_return, args, ctx)
      end

      alias resolve_field resolve

      private

      def apply_scope(scope, root, arguments, context)
        return root unless scope

        record = @record || root
        return scope.call(record, arguments, context) if scope.respond_to?(:call)

        scope = infer_scope(record) if scope.equal?(true)
        scope::Scope.new(context[self.class.current_user], record).resolve
      end

      def infer_scope(root)
        infer_from = model?(root) ? root.model : root
        ::Pundit::PolicyFinder.new(infer_from).policy!
      end
    end
  end
end
