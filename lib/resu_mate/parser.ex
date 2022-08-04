defmodule ResuMate.ParserError do
  @type t :: %__MODULE__{file: String.t()}

  defexception [:file]

  def message(%{file: file}) do
    "OOPS! Couldn't parse" <> inspect(file)
  end
end

defmodule ResuMate.Parser do
  @moduledoc false

  alias ResuMate.ParserError

  @doc """
  Returns the data (`Map.t()`) yielded by parsing a resume file 

  ## Examples

      ResuMate.parse("/path/to/resume.yml")
      {:ok, resume_data}
  """
  @spec parse(Path.t()) :: {:ok, Map.t()} | {:error, ParserError.t()}
  def parse(filepath) do
    {:ok, "Got " <> filepath <> " :)"}
  end
end
