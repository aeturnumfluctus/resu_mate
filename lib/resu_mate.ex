defmodule ResuMate do
  @moduledoc """
  Generates resume files with a specified format via parsing a file containing
  the resume's source data. 

  ## Examples

  **TODO**
  """

  alias ResuMate.{Parser, ParserError}

  @doc """
  Returns the data (`Map.t()`) yielded by parsing a resume file 

  ## Examples

      ResuMate.parse("/path/to/resume.yml")
      {:ok, resume_data}
  """
  @spec parse(Path.t()) :: {:ok, Map.t()} :: {:error, ParserError.t()}
  def parse(path_to_file), do: Parser.parse(path_to_file)
end
