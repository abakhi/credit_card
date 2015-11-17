# CreditCard

[![Build Status](https://travis-ci.org/abakhi/credit_card.svg?branch=master)](https://travis-ci.org/abakhi/credit_card)


Elixir library for validating credit card numbers (a port of [credit_card_validator](https://github.com/tobias/credit_card_validator) Ruby gem)


## Documentation

API documentation can be found at [http://hexdocs.pm/credit_card](http://hexdocs.pm/credit_card)

## TODO

Incorporate some ideas from [Card](https://github.com/jessepollak/card)

* Check CVC length and number length
* Differentiate between VISA and VISA electron

## Installation

The package can be installed as:

  1. Add credit_card to your list of dependencies in `mix.exs`:

        def deps do
          [{:credit_card, "~> 0.0.1"}]
        end
