defmodule ResuMate.Generator do
  @moduledoc false

  alias ResuMate.{Generator, GeneratorError}

  alias Generator.MarkdownGenerator

  @spec generate(binary(), Map.t()) :: {:ok, term} | {:error, GeneratorError.t()}
  def generate(filepath, resume_data) do
    case generator().generate(resume_data) do
      {:ok, content} ->
        File.open(filepath, [:write], &IO.puts(&1, content))

        {:ok, filepath}

      error_tup ->
        error_tup
    end
  end

  defp generator(), do: Application.get_env(:resu_mate, :generator, MarkdownGenerator)
end
