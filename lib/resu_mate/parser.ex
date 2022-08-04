defmodule ResuMate.Parser do
  @doc """
  Returns the data (`Map.t()`) yielded by parsing a resume file 

  ## Examples

      ResuMate.parse("/path/to/resume.yml")
      {:ok, resume_data}
  """
  # TODO: {:error, ParseError.t()}
  @spec parse(Path.t()) :: {:ok, Map.t()} :: {:error, term}
  def parse(filepath) do
    {:ok, "Got " <> filepath <> " :)"}
  end
end
