# frozen_string_literal: true

require_relative './has_directives'

module GraphQL::SchemaDirectives
  module InitializeWithDirectives
    include HasDirectives

    def initialize(*args, directives: nil, **kwargs, &block)
      if directives
        raise ArgumentError, 'schema directives must be a hash' unless directives.is_a?(Hash)
        directives.each_pair { |name, arguments| add_directive(name, arguments) }
      end
      super(*args, **kwargs, &block)
    end
  end
end
