defmodule ResuMate.GeneratorError do
  defexception [:message]

  @type t :: %__MODULE__{message: String.t()}

  @impl true
  def exception(%{message: message}) do
    "unable to successfully complete generation"
  end
end

defmodule ResuMate.GeneratorBehaviour do
  @moduledoc false

  alias ResuMate.GeneratorError

  # or, e.g.) .docx, .txt, etc
  @type file_extension :: :md

  @doc """
  Returns a string (`String.t()`) corresponding to the filepath of the generated 
  file.
  """
  @callback generate(Map.t()) :: {:ok, String.t()} | {:error, GeneratorError.t()}
end
