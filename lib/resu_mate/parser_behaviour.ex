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
  Returns a map of the data (`Map.t()`) yielded by parsing the provided resume file 

  """
  @callback parse(binary()) :: {:ok, Map.t()} | {:error, ParserError.t()}

end
