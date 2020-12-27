# frozen_string_literal: true

require 'graphql/schema-directives/version'
require 'graphql/schema-directives/types'

module GraphQL::SchemaDirectives
  def self.from_definition(*args, **kwargs, &block)
    schema = GraphQL::Schema.from_definition(*args, **kwargs, &block)
    schema.include(GraphQL::SchemaDirectives::Schema)
    schema
  end
end
