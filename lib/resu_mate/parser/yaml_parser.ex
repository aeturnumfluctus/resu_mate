defmodule ResuMate.Parser.YamlParser do
  @moduledoc false
  
  @behaviour ResuMate.ParserBehaviour

  alias ResuMate.ParserError


  @impl true
  def parse(filepath) do
    case YamlElixir.read_from_file(filepath) do
      {:error, error} -> {:error, error_for(error)}
      result -> result
    end
  end

  defp error_for(error), do: %ParserError{message: error.message}
end
