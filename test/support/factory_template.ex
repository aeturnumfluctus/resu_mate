defmodule ResuMate.FactoryTemplate do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def boolean(), do: Enum.random([true, false])
      def integer(range \\ -3_000..3_000), do: Enum.random(range)
      def url(), do: "https://" <> Faker.Internet.domain_name()
      def email(), do: Faker.Internet.email()
      def first_name(), do: Faker.Person.first_name()
      def last_name(), do: Faker.Person.last_name()
      def word(), do: Faker.Lorem.word()
      def paragraph(), do: Faker.Lorem.paragraph()
      def sentence(), do: Faker.Lorem.sentence()
    end
  end
end
