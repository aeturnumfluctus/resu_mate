defmodule ResuMate.ParserError do
  defexception [:message]

  @type t :: %__MODULE__{message: String.t()}

  @impl true
  def exception(%{message: message}) do
    "unable to successfully parse"
  end
end

defmodule ResuMate.ParserBehaviour do
  @moduledoc false

  alias ResuMate.ParserError
  
  @doc """
  Returnss a map the data (`Map.t()`) yielded by parsing the provided resume file 

  """
  @callback parse(binary()) :: {:ok, map()} | {:error, ParserError.t()}

  # @doc """
  # Returns the data (`Map.t()`) yielded by parsing a resume file 

  # ## Examples

  #     ResuMate.parse("/path/to/resume.yml")
  #     {:ok, resume_data}
  # """
  # @spec parse(Path.t()) :: {:ok, Map.t()} | {:error, ParserError.t()}
  # def parse(filepath) do
  #   # parser(:yaml)
  #   {:ok, "Got " <> filepath <> " :)"}
  # end

  # defp parser(:yaml), do: YamlElixir
end
