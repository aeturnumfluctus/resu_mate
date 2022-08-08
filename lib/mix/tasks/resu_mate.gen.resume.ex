defmodule Mix.Tasks.ResuMate.Gen.Resume do
  @moduledoc "Generates a resume from a source resume.yml file"
  @shortdoc "Generates a resume"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    params = build_params_from_args(args)

    prompt_for_confirmation(params)
    |> case do
      false ->
        Mix.shell().info("Generation cancelled")

      _ ->
        params
        |> ResuMate.generate_resume()
        |> print_generator_results()
    end
  end

  defp build_params_from_args(args) do
    [file_to_generate, _, source_resume_file] = args
    [as: Path.expand(file_to_generate), from: Path.expand(source_resume_file)]
  end

  defp prompt_for_confirmation(params) do
    params
    |> build_confirmation_prompt()
    |> Mix.shell().yes?()
  end

  defp build_confirmation_prompt(params) do
    base_prompt = """
    You're about to generate a resume named: 

    \t#{Path.relative_to_cwd(params[:as])}

    based on data from: 

    \t#{Path.relative_to_cwd(params[:from])}
    """

    base_prompt
    |> maybe_add_already_exists_string(params)
    |> Kernel.<>("\nContinue?")
  end

  defp maybe_add_already_exists_string(prompt_txt, params) do
    if File.exists?(Path.expand(params[:as])) do
      prompt_txt <>
        "\n(note: #{Path.relative_to_cwd(params[:as])} already exists.)\n"
    else
      prompt_txt
    end
  end

  defp print_generator_results({:ok, generated_file}) do
    [:green, "Successfully generated resume!\n"] |> IO.ANSI.format() |> IO.write()
    Mix.shell().info("generated: #{generated_file}")
  end

  defp print_generator_results({:error, reason}) do
    Mix.shell().error("Failed to generate resume :(\n")
    Mix.shell().error(reason.message)
  end
end
