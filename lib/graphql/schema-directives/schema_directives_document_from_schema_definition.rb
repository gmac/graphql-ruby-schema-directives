# frozen_string_literal: true

require 'graphql'

module GraphQL::SchemaDirectives
  class SchemaDirectivesDocumentFromSchemaDefinition < GraphQL::Language::DocumentFromSchemaDefinition

    def build_object_type_node(object_type)
      node = super
      merge_directives(node, object_type)
    end

    def build_interface_type_node(interface_type)
      node = super
      merge_directives(node, interface_type)
    end

    def build_field_node(field_type)
      node = super
      merge_directives(node, field_type)
    end

    def build_input_object_node(input_object)
      node = super
      merge_directives(node, input_object)
    end

    def build_argument_node(argument)
      node = super
      merge_directives(node, argument)
    end

    def build_union_type_node(union_type)
      node = super
      merge_directives(node, union_type)
    end

    def build_enum_type_node(enum_type)
      node = super
      merge_directives(node, enum_type)
    end

    def build_enum_value_node(enum_value)
      node = super
      merge_directives(node, enum_value)
    end

    private

    def merge_directives(node, member)
      directives = if member.respond_to?(:metadata)
        member.metadata[:schema_directives]
      elsif member.respond_to?(:schema_directives)
        member.schema_directives
      end

      (directives || []).each do |directive|
        node = node.merge_directive(
          name: directive[:name],
          arguments: build_arguments_node(directive[:arguments]),
        )
      end
      node
    end

    def build_arguments_node(arguments)
      (arguments || {}).map do |name, values|
        GraphQL::Language::Nodes::Argument.new(name: name, value: values)
      end
    end
  end
end
