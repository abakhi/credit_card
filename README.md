# CreditCard

[![Build Status](https://travis-ci.org/abakhi/credit_card.svg?branch=master)](https://travis-ci.org/abakhi/credit_card)


Elixir library for validating credit card numbers (a port of [credit_card_validator](https://github.com/tobias/credit_card_validator) Ruby gem)


## Documentation

See the tests folder for examples of how to use this library.

API documentation can be found at [http://hexdocs.pm/credit_card](http://hexdocs.pm/credit_card)

### Using with Phoenix and Ecto

```elixir
defmodule MyApp.Card do
  use MyApp.Web, :model

  schema "cards" do
    field :card_number, :integer
    field :name_on_card, :string
    field :valid_from, Ecto.Date
    field :expires, Ecto.Date
    timestamps
  end

  @required_fields ~w(card_number name_on_card valid_from expires)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_credit_card(:card_number)
  end

  def validate_credit_card(changeset, field \\ :card_number, opts \\ []) do
    validate_change changeset, field, fn _field, number ->
      message = opts[:message] || "Invalid credit card number"
      if CreditCard.valid?(to_string(number)) do
        []
      else
        [field, message]
      end
    end
  end
end
```

## TODO

Incorporate some ideas from [Card](https://github.com/jessepollak/card)

* Check CVC length and number length
* Differentiate between VISA and VISA electron

## Installation

The package can be installed as:

  1. Add credit_card to your list of dependencies in `mix.exs`:

        def deps do
          [{:credit_card, "~> 1.0.0"}]
        end
