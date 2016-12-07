defmodule CreditCardTest do
  use ExUnit.Case
  doctest CreditCard

  @card_opts  CreditCard.new

  test "recognize card type" do
    assert CreditCard.card_type("4111111111111111") == :visa
    assert CreditCard.card_type("5555555555554444") == :master_card
    assert CreditCard.card_type("30569309025904")   == :diners_club
    assert CreditCard.card_type("371449635398431")  == :amex
    assert CreditCard.card_type("6011000990139424") == :discover
    assert CreditCard.card_type("6759671431256542") == :maestro
    assert CreditCard.card_type("3530111333300000") == :jcb
    assert CreditCard.card_type("6212341111111111") == :unionpay
  end

  test "detect specific types" do
    assert CreditCard.card_is("4111111111111111", :visa)
    assert !CreditCard.card_is("5555555555554444", :visa)
    assert !CreditCard.card_is("30569309025904", :visa)
    assert !CreditCard.card_is("371449635398431", :visa)
    assert !CreditCard.card_is("6011000990139424", :visa)
    assert CreditCard.card_is("5555555555554444", :master_card)
    assert CreditCard.card_is("30569309025904", :diners_club)
    assert CreditCard.card_is("371449635398431", :amex)
    assert CreditCard.card_is("6011000990139424", :discover)
    assert CreditCard.card_is("6759671431256542", :maestro)
    assert !CreditCard.card_is("5555555555554444", :maestro)
    assert !CreditCard.card_is("30569309025904", :maestro)
    assert CreditCard.card_is("3530111333300000", :jcb)
    assert !CreditCard.card_is("6759671431256542", :jcb)
    assert CreditCard.card_is("6212341111111111", :unionpay)
    assert !CreditCard.card_is("5555555555554444", :unionpay)
  end

  test "luhn verification" do
    assert CreditCard.verify_luhn("49927398716")
    assert CreditCard.verify_luhn("049927398716")
    assert CreditCard.verify_luhn("0049927398716")
    assert !CreditCard.verify_luhn("49927398715")
    assert !CreditCard.verify_luhn("49927398717")
  end

  test "ignore whitespace" do
    assert :visa == CreditCard.card_type("4111 1111 1111 1111 ")
    assert :visa == CreditCard.card_type(" 4111 1111 1111 1111 ")
    assert CreditCard.verify_luhn(" 004 992739 87 16")
    assert CreditCard.is_test_number("601 11111111111 17")
  end

  test "should recognize test numbers" do
    ~w(
      378282246310005 371449635398431 378734493671000
      30569309025904 38520000023237 6011111111111117
      6011000990139424 5555555555554444 5105105105105100
      4111111111111111 4012888888881881 4222222222222
      3530111333300000 3566002020360505
    ) |> Enum.each(&(assert CreditCard.is_test_number(&1)))

    assert !CreditCard.is_test_number("1234")
  end

  test "test number validity cases" do
    assert !CreditCard.valid?("378282246310005")
    opts = %{@card_opts|test_numbers_are_valid: true}
    assert CreditCard.valid?("378282246310005", opts)
  end

  test "is allowed card type" do
    assert CreditCard.is_allowed_card_type?("378282246310005")
    opts = %{@card_opts|allowed_card_types: [:visa]}
    assert CreditCard.is_allowed_card_type?("4012888888881881", opts)
    assert !CreditCard.is_allowed_card_type?("378282246310005", opts)

  end

  test "card type allowance" do
    opts = %{@card_opts|test_numbers_are_valid: true}
    assert CreditCard.valid?("378282246310005", opts)
    opts = %{opts|allowed_card_types: [:visa]}
    assert CreditCard.valid?("4012888888881881", opts)
    assert !CreditCard.valid?("378282246310005", opts)

  end

end
