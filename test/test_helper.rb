# frozen_string_literal: true

require 'warning'
Gem.path.each do |path|
  # ignore warnings from auto-generated GraphQL lib code.
  # makes our test suite run without hundreds of lines of benign warnings
  Warning.ignore(/.*mismatched indentations.*/)
  Warning.ignore(/.*splat keyword arguments.*/)
  Warning.ignore(/.*passed as a single Hash.*/)
  Warning.ignore(/.*instance variable @\w+ not initialized*/)
end

require 'bundler/setup'
Bundler.require(:default, :test)

require 'minitest/pride'
require 'minitest/autorun'
require 'graphql-schema-directives'

def assert_not(val)
  assert !val
end

def assert_not_equal(exp, val)
  assert exp != val
end

def assert_include(exp, val)
  assert exp.strip.gsub(/\s+/, ' ').include?(val.strip.gsub(/\s+/, ' '))
end

class BaseField < GraphQL::Schema::Field
  include GraphQL::SchemaDirectives::Field
end

class BaseObject < GraphQL::Schema::Object
  include GraphQL::SchemaDirectives::Object
  field_class BaseField
end

module BaseInterface
  include GraphQL::Schema::Interface
  include GraphQL::SchemaDirectives::Interface
  field_class BaseField
end

class BaseUnion < GraphQL::Schema::Union
  include GraphQL::SchemaDirectives::Union
end

class BaseArgument < GraphQL::Schema::Argument
  include GraphQL::SchemaDirectives::Argument
end

class BaseInputObject < GraphQL::Schema::InputObject
  include GraphQL::SchemaDirectives::InputObject
  argument_class BaseArgument
end

class BaseEnumValue < GraphQL::Schema::EnumValue
  include GraphQL::SchemaDirectives::EnumValue
end

class BaseEnum < GraphQL::Schema::Enum
  include GraphQL::SchemaDirectives::Enum
  enum_value_class BaseEnumValue
end

# class BaseScalar < GraphQL::Schema::Scalar
#   include GraphQL::SchemaDirectives::Scalar
# end

class SecondDirective < GraphQL::Schema::Directive
  graphql_name 'second'
  locations 'OBJECT', 'FIELD_DEFINITION'
end
