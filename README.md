# Ruby GraphQL Schema Directives

This gem extends [GraphQL Ruby](http://graphql-ruby.org/) to add support for custom schema directives that annotate an SDL. These annotations are useful for [Schema Stitching](https://www.graphql-tools.com/docs/stitch-directives-sdl), [Apollo Federation](https://www.apollographql.com/docs/federation/), and other proprietary uses.

This gem is intentionally generic, unlike the [apollo-federation](https://github.com/Gusto/apollo-federation-ruby) gem upon which it is based. The goals of this gem are very simple:

1. allow schema directives to be applied to any GraphQL element, and then printed into an annotated SDL. See [Class-based schemas](#class-based-schemas).
2. allow class-based schemas and `from_definition` schemas to be combined and printed together. See [Schemas from definition](#schemas-from-definition).

## Installation

Add to Gemfile:

```ruby
gem 'graphql-schema-directives'
```

Then install:

```shell
bundle install
```

## Class-based schemas

There's a typed mixin available for extending all GraphQL schema members.

### Schemas

Include the schema mixin:

```ruby
class MySchema < GraphQL::Schema
  include GraphQL::SchemaDirectives::Schema
end
```

This adds a `print_schema_with_directives` method to print an SDL that includes custom schema directives:

```ruby
MySchema.print_schema_with_directives
```

### Fields, Objects &amp; Interfaces

Setup base abstracts:

```ruby
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
```

Then extend into concrete implementations:

```ruby
module Spaceship
  include BaseInterface
  add_directive :attribute, { speed: 'average' }

  field :name, String, null: false, directives: {
    cost: { value: 'FIELD' },
    public: nil
  }
end

class XWing < BaseObject
  implements Spaceship
  add_directive :attribute, { speed: 'fast' }
  add_directive :rebel

  field :name, String, null: false, directives: {
    cost: { value: 'FIELD' },
    public: nil
  }
end
```

Prints from `schema.print_schema_with_directives` as:

```graphql
interface Spaceship @attribute(speed: "average") {
  name: String! @cost(value: "FIELD") @public
}

type XWing @attribute(speed: "fast") @rebel {
  name: String! @cost(value: "FIELD") @public
}
```

### Arguments &amp; InputObjects

Base abstracts:

```ruby
class BaseArgument < GraphQL::Schema::Argument
  include GraphQL::SchemaDirectives::Argument
end

class BaseInputObject < GraphQL::Schema::InputObject
  include GraphQL::SchemaDirectives::InputObject
  argument_class BaseArgument
end
```

Concrete implementation:

```ruby
class FormInput < BaseInputObject
  add_directive :oneField
  argument :choice, String, required: true, directives: {
    cost: { value: 'INPUT' },
    public: nil
  }
end
```

Prints as:

```graphql
input FormInput @oneField {
  choice: String! @cost(value: "INPUT") @public
}
```

### Enums &amp; values

Base abstracts:

```ruby
class BaseEnumValue < GraphQL::Schema::EnumValue
  include GraphQL::SchemaDirectives::EnumValue
end

class BaseEnum < GraphQL::Schema::Enum
  include GraphQL::SchemaDirectives::Enum
  enum_value_class BaseEnumValue
end
```

Concrete implementation:

```ruby
class FormOption < BaseEnum
  add_directive :dunno
  value 'GET', directives: { cost: { value: 'READ' }, public: nil }
  value 'SET', directives: { cost: { value: 'WRITE' }, public: nil }
end
```

Prints as:

```graphql
enum FormOption @dunno {
  GET @cost(value: "READ") @public
  SET @cost(value: "WRITE") @public
}
```

### Other types

Base abstracts:

```ruby
class BaseUnion < GraphQL::Schema::Union
  include GraphQL::SchemaDirectives::Union
end

class BaseScalar < GraphQL::Schema::Scalar
  include GraphQL::SchemaDirectives::Scalar
end
```

## Schemas from definition

You may also [parse and print SDLs](https://graphql-ruby.org/schema/sdl.html) using the gem's `from_definition` method:

```rb
schema = GraphQL::SchemaDirectives.from_definition(type_defs)
puts schema.print_schema_with_directives
```

The local `from_definition` method accepts all the same options as [the underlying method](https://graphql-ruby.org/api-doc/1.11.6/GraphQL/Schema#from_definition-class_method). Calling `print_schema_with_directives` works exactly like the [default printer](https://graphql-ruby.org/api-doc/1.11.6/GraphQL/Language/Printer.html#print-instance_method) when operating on an unmodified document parse (elements with an original AST will print their schema directives natively).

This feature becomes useful when you start modifying a parsed document with class-based additions:

```rb
module Spaceship
  include GraphQL::Schema::Interface
  include GraphQL::SchemaDirectives::Interface
  field :name, String, null: false, directives: { public: nil }
end

type_defs = %(
  type XWing {
    name: String! @public
  }
  type Query {
    ship: XWing
  }
  schema {
    query: Query
  }
)

schema = GraphQL::SchemaDirectives.from_definition(type_defs)
schema.types['XWing'].implements(Spaceship)
puts schema.print_schema_with_directives
```

Using `print_schema_with_directives` will include directives from the original AST as well as directives applied to added classes.
