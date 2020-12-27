# frozen_string_literal: true

require 'test_helper'

TYPE_DEFS = %Q(
  directive @first(arg: String!) on OBJECT | FIELD_DEFINITION

  type XWing @first(arg: "yes") @second {
    id: ID!
    name: String! @first(arg: "yes") @second
  }

  type Query {
    ship: XWing @first(arg: "yes") @second
  }

  schema {
    query: Query
  }
)

module Spaceship
  include BaseInterface
  add_directive :first, { arg: 'yes' }
  add_directive :second

  field :id, ID, null: false
  field :name, String, null: false, directives: { first: { arg: 'yes' }, second: nil }
end

describe 'GraphQL::SchemaDirectives.from_definition' do
  before do
    schema = GraphQL::SchemaDirectives.from_definition(TYPE_DEFS)
    schema.types['XWing'].implements(Spaceship)
    schema.directive(SecondDirective)
    @result = schema.print_schema_with_directives
  end

  it 'formats Query type' do
    assert_include @result, %(
      type Query {
        ship: XWing @first(arg: "yes") @second
      }
    )
  end

  it 'formats modified Object type' do
    assert_include @result, %(
      type XWing implements Spaceship @first(arg: "yes") @second {
        id: ID!
        name: String! @first(arg: "yes") @second
      }
    )
  end

  it 'formats inserted class type' do
    assert_include @result, %(
      interface Spaceship @first(arg: "yes") @second {
        id: ID!
        name: String! @first(arg: "yes") @second
      }
    )
  end

  it 'formats directive from definition' do
    assert_include @result, %(
      directive @first(arg: String!) on OBJECT | FIELD_DEFINITION
    )
  end

  it 'formats directive from class addition' do
    assert_include @result, %(
      directive @second on OBJECT | FIELD_DEFINITION
    )
  end
end
