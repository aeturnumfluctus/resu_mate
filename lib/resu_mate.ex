defmodule ResuMate do
  @moduledoc """
  Generates resume files with a specified format via parsing a file containing
  the resume's source data. 

  ## Examples

  **TODO**
  """

  alias ResuMate.{Parser, ParserError}

  @type resume_data :: Map.t()

  @doc """
  Returns a success tuple containing the data (`Map.t()`) yielded by parsing a 
  `resume_filepath` 

  ## Examples

      ResuMate.parse("/path/to/resume.yml")
      {:ok, resume_data}
  """
  @spec parse(Path.t()) :: {:ok, Map.t()} | {:error, ParserError.t()}
  def parse(resume_filepath), do: Parser.parse(resume_filepath)


  @doc """
  Returns the data (`Map.t()`) yielded by parsing `resume_filepath`

  If parsing fails, a `ParserError` is raised.

  ## Examples

      ResuMate.parse("/path/to/resume.yml")
  """
  @spec parse!(Path.t()) :: resume_data | no_return()
  def parse!(filepath) do
    case parse(filepath) do
      {:ok, data} -> data
      {_, error} -> raise error
    end
  end
end
