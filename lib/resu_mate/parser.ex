defmodule ResuMate.Parser do
  @moduledoc false

  alias ResuMate.{Parser, ParserError}

  alias Parser.YamlParser

  @spec parse(binary()) :: {:ok, term} | {:error, ParserError.t()}
  def parse(filepath) do
    parser().parse(filepath)
  end

  defp parser(), do: Application.get_env(:resu_mate, :parser, YamlParser)
end
