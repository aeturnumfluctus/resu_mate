defmodule ResuMate do
  @moduledoc """
  Generates resume files with a specified format via parsing a file containing
  the resume's source data. 

  ## Examples

  To generate a markdown-formatted resume named `/path/to/resume.md` from existing 
  data in `/path/to/resume_data.yml`:

      ResuMate.generate_resume(
        from: "/path/to/resume_data.yml", 
        as: "/path/to/resume.md"
      )
  """

  alias ResuMate.{Generator, GeneratorError, Parser, ParserError}

  @type resume_data :: Map.t()
  @type filepath :: String.t()

  @doc """
  Returns a success tuple containing the data (`Map.t()`) yielded by parsing a 
  `resume_filepath` 

  ## Examples

      ResuMate.parse("/path/to/resume.yml")
      {:ok, resume_data}
  """
  @spec parse(filepath) :: {:ok, resume_data} | {:error, ParserError.t()}
  def parse(resume_filepath), do: Parser.parse(resume_filepath)

  @doc """
  Returns the data (`Map.t()`) yielded by parsing `resume_filepath`

  If parsing fails, a `ParserError` is raised.

  ## Examples

      ResuMate.parse("/path/to/resume.yml")
  """
  @spec parse!(filepath) :: resume_data | no_return()
  def parse!(filepath) do
    case parse(filepath) do
      {:ok, data} -> data
      {_, error} -> raise error
    end
  end

  @doc """
  Returns a success tuple containing the path to the generated resume file 

  ## Examples

      ResuMate.generate_resume(TODO)

  """
  @spec generate_resume([{:from, filepath}, {:as, filepath}]) ::
          {:ok, filepath} | {:error, GeneratorError.t()}
  def generate_resume(opts) do
    with source_resume_file <- Keyword.fetch!(opts, :from),
         destination_resume_filepath <- Keyword.fetch!(opts, :as),
         {:ok, resume_data} <- parse(source_resume_file) do
      Generator.generate(destination_resume_filepath, resume_data)
    else
      err_tup -> err_tup
    end
  end
end
