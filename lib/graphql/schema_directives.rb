# frozen_string_literal: true

require 'graphql/schema_directives/version'
require 'graphql/schema_directives/types'

module GraphQL::SchemaDirectives
  def self.from_definition(*args, **kwargs, &block)
    schema = GraphQL::Schema.from_definition(*args, **kwargs, &block)
    schema.include(GraphQL::SchemaDirectives::Schema)
    schema
  end
end
