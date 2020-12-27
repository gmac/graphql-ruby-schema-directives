# frozen_string_literal: true

require 'graphql'
require_relative './has_directives'
require_relative './initialize_with_directives'
require_relative './schema_directives_document_from_schema_definition'

module GraphQL::SchemaDirectives
  module Argument
    include InitializeWithDirectives
  end

  module Enum
    def self.included(klass)
      klass.extend(HasDirectives)
    end
  end

  module EnumValue
    include InitializeWithDirectives
  end

  module Field
    include InitializeWithDirectives
  end

  module InputObject
    def self.included(klass)
      klass.extend(HasDirectives)
    end
  end

  module Interface
    def self.included(klass)
      klass.definition_methods do
        include HasDirectives
      end
    end
  end

  module Object
    def self.included(klass)
      klass.extend(HasDirectives)
    end
  end

  module Scalar
    def self.included(klass)
      klass.extend(HasDirectives)
    end
  end

  module Schema
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def print_schema_with_directives(context: nil)
        document_from_schema = SchemaDirectivesDocumentFromSchemaDefinition.new(self, context: context)
        GraphQL::Language::Printer.new.print(document_from_schema.document)
      end
    end
  end

  module Union
    def self.included(klass)
      klass.extend(HasDirectives)
    end
  end
end
