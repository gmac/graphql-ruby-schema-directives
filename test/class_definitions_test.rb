# frozen_string_literal: true

require 'test_helper'

class FirstDirective < GraphQL::Schema::Directive
  graphql_name 'first'
  add_argument GraphQL::Schema::Argument.new('arg', String, required: true, owner: GraphQL::Schema)
  locations 'OBJECT', 'FIELD_DEFINITION'
end

module Widget
  include BaseInterface
  add_directive :first, { arg: 'yes' }
  add_directive :second

  field :id, ID, null: false
  field :name, String, null: false, directives: { first: { arg: 'yes' }, second: nil }
end

class Sprocket < BaseObject
  implements Widget
  add_directive :first, { arg: 'yes' }
  add_directive :second

  field :id, ID, null: false
  field :name, String, null: false, directives: { first: { arg: 'yes' }, second: nil }
end

class SprocketValue < BaseEnum
  add_directive :first, { arg: 'yes' }
  add_directive :second
  value 'OKAY', directives: { first: { arg: 'yes' }, second: nil }
end

class SprocketInput < BaseInputObject
  add_directive :first, { arg: 'yes' }
  add_directive :second
  argument :value, SprocketValue, required: true, directives: { first: { arg: 'yes' }, second: nil }
end

class Gizmo < BaseUnion
  add_directive :first, { arg: 'yes' }
  add_directive :second
  possible_types Sprocket
end

# class Thing < BaseScalar
#   add_directive :first, { arg: 'yes' }
#   add_directive :second

#   def self.coerce_input(val)
#     val
#   end

#   def self.coerce_result(val)
#     val.to_s
#   end
# end

class Query < BaseObject
  field :gizmo, Gizmo, null: true
  field :sprocket, Sprocket, null: true, directives: { first: { arg: 'yes' }, second: nil } do
    argument :input, SprocketInput, required: true
  end
  # field :thing, Thing, null: true
end

class TestSchema < GraphQL::Schema
  include GraphQL::SchemaDirectives::Schema
  directive(FirstDirective)
  directive(SecondDirective)
  query(Query)
end

describe 'GraphQL::SchemaDirectives via Classes' do
  before do
    @result = TestSchema.print_schema_with_directives
  end

  it 'formats Query type' do
    assert_include @result, %(
      type Query {
        gizmo: Gizmo
        sprocket(input: SprocketInput!): Sprocket @first(arg: "yes") @second
      }
    )
  end

  it 'formats Interface type' do
    assert_include @result, %(
      interface Widget @first(arg: "yes") @second {
        id: ID!
        name: String! @first(arg: "yes") @second
      }
    )
  end

  it 'formats Object type' do
    assert_include @result, %(
      type Sprocket implements Widget @first(arg: "yes") @second {
        id: ID!
        name: String! @first(arg: "yes") @second
      }
    )
  end

  it 'formats InputObject type' do
    assert_include @result, %(
      input SprocketInput @first(arg: "yes") @second {
        value: SprocketValue! @first(arg: "yes") @second
      }
    )
  end

  it 'formats Union type' do
    assert_include @result, %(
      union Gizmo @first(arg: "yes") @second = Sprocket
    )
  end

  it 'formats Enum type' do
    assert_include @result, %(
      enum SprocketValue @first(arg: "yes") @second {
        OKAY @first(arg: "yes") @second
      }
    )
  end

  it 'formats directive definitions' do
    assert_include @result, %(directive @first(arg: String!) on OBJECT | FIELD_DEFINITION)
    assert_include @result, %(directive @second on OBJECT | FIELD_DEFINITION)
  end
end
