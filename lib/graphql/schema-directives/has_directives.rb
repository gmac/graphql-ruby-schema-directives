# frozen_string_literal: true

module GraphQL::SchemaDirectives
  module HasDirectives
    attr_reader :schema_directives

    def add_directive(name, arguments=nil)
      raise ArgumentError, 'directive name must be a string or symbol' unless name.is_a?(String) || name.is_a?(Symbol)
      raise ArgumentError, 'directive arguments must be a Hash or nil' unless arguments.is_a?(Hash) || arguments.nil?
      @schema_directives ||= []
      @schema_directives << {
        name: name,
        arguments: arguments
      }
    end

    def to_graphql
      type = super
      type.metadata[:schema_directives] = @schema_directives
      type
    end
  end
end
