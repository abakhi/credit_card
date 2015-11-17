defmodule CreditCard do
  @moduledoc """
  Credit card validations library
  """
  @card_types [
    visa: ~r/^4[0-9]{12}(?:[0-9]{3})?$/,
    master_card: ~r/^5[1-5][0-9]{14}$/,
    maestro:  ~r/(^6759[0-9]{2}([0-9]{10})$)|(^6759[0-9]{2}([0-9]{12})$)|(^6759[0-9]{2}([0-9]{13})$)/,
    diners_club: ~r/^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
    amex: ~r/^3[47][0-9]{13}$/,
    discover: ~r/^6(?:011|5[0-9]{2})[0-9]{12}$/,
    jcb: ~r/^(?:2131|1800|35\d{3})\d{11}$/
  ]

  @test_numbers [
    amex: ~w(378282246310005 371449635398431 378734493671000 ),
    diners_club: ~w(30569309025904 38520000023237 ),
    discover: ~w(6011000990139424 6011111111111117 ),
    master_card: ~w(5555555555554444 5105105105105100 ),
    visa: ~w(
      4111111111111111 4012888888881881 4222222222222
      4005519200000004 4009348888881881 4012000033330026
      4012000077777777 4217651111111119 4500600000000061
      4000111111111115 ),
    jcb: ~w(3530111333300000 3566002020360505)
  ] |> Keyword.values |> List.flatten

  @opts %{
            allowed_card_types: Keyword.keys(@card_types),
            test_numbers_are_valid: false
        }

  @type opts :: %{atom => String.t}
  @type validation_error :: {:error, :unrecognized_card_type}

  @doc """
  Returns CreditCard options map.
  """
  @spec new :: opts
  def new, do: @opts

  @doc """
  Returns True if card matches the allowed card patterns. By default,
  the set of cards matched against are Amex, VISA, MasterCard, Discover,
  Diners Club and JCB. Otherwise, false

  ## Examples

     iex> CreditCard.valid?("4000111111111115")
     false
  """
  @spec valid?(String.t, opts) :: boolean
  def valid?(number, opts \\ @opts) do
    case card_type(number) do
      {:error, _err_msg} ->
        false
      type when is_atom(type) ->
        valid_card? = (is_allowed_card_type?(number, opts)
                       && verify_luhn(number))
        valid_card? &&
        (if opts[:test_numbers_are_valid] do
           true
         else
           !is_test_number(number)
         end)
    end
  end

  @doc """
  Returns true if the validation options is set to recognize the card's class.
  Otherwise, false.

  ## Examples

      iex> CreditCard.is_allowed_card_type?("5555555555554444")
      true
  """
  @spec is_allowed_card_type?(String.t, opts) :: boolean
  def is_allowed_card_type?(number, opts \\ @opts) do
    case card_type(number) do
      {:error, _err_msg} ->
        false
      type when is_atom(type) ->
        allowed? = (opts[:allowed_card_types]
                    && (type in opts[:allowed_card_types]))
        if allowed?, do: true, else: false
    end
  end

  @doc """
  Returns true if number is among the list of test credit card numbers
  ;otherwise, it returns false.
  """
  @spec is_test_number(String.t) :: boolean
  def is_test_number(number) do
    strip(number) in @test_numbers
  end

  @doc """
  Performs luhn check on the credit card number
  """
  @spec verify_luhn(String.t) :: boolean
  def verify_luhn(number) do
    total =
      number |> strip |> String.reverse |> String.split("")
      |> Enum.reject(&(&1 == ""))
      |> Enum.reduce([0,0], fn x, acc ->
        n = String.to_integer(x)
        [acc_h, acc_t] = Enum.slice(acc, 0, 2)
        val = (if((rem(acc_t,2) == 1), do: rotate(n*2), else: n))
        [acc_h + val, acc_t + 1|acc]
    end)

    rem(Enum.at(total,0),10) == 0
  end

  @doc """
  Returns the type of card

  ## Examples

      iex> CreditCard.card_type("3566002020360505")
      :jcb
  """
  @spec card_type(String.t) :: atom | validation_error
  def card_type(number) do
    card_type = (Keyword.keys(@card_types)
                 |> Enum.filter(&(card_is(strip(number), &1))))
    case card_type do
      [h|_] -> h
      _ -> {:error, :unrecognized_card_type}
    end
  end

  @spec strip(String.t) :: String.t
  defp strip(number) do
    number
    |> String.split("")
    |> Enum.reject(&(&1 in ["", " "]))
    |> Enum.join("")
  end

  @spec card_is(String.t, atom) :: boolean
  def card_is(number, :visa) do
    @card_types[:visa] |> Regex.match?(number)
  end

  def card_is(number, :master_card) do
    @card_types[:master_card] |> Regex.match?(number)
  end

  def card_is(number, :maestro) do
    @card_types[:maestro] |> Regex.match?(number)
  end

  def card_is(number, :diners_club) do
    @card_types[:diners_club] |> Regex.match?(number)
  end

  def card_is(number, :discover) do
    @card_types[:discover] |> Regex.match?(number)
  end

  def card_is(number, :amex) do
    @card_types[:amex] |> Regex.match?(number)
  end

  def card_is(number, :jcb) do
    @card_types[:jcb] |> Regex.match?(number)
  end

  @spec rotate(String.t) :: String.t
  defp rotate(number) do
    if number > 9, do: number = rem(number,10) + 1
    number
  end
end
