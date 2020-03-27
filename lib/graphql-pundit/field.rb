# frozen_string_literal: true

require 'graphql'
require 'graphql-pundit/authorization'
require 'graphql-pundit/scope'

module GraphQL
  # Our custom pundit module
  module Pundit
    # Field class that contains authorization and scope behavior
    # This only works with graphql >= 1.8.0
    class Field < GraphQL::Schema::Field
      prepend GraphQL::Pundit::Scope
      prepend GraphQL::Pundit::Authorization
    end
  end
end
