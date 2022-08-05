defmodule ResuMate.Generator.MarkdownGenerator do
  @moduledoc false
  
  @behaviour ResuMate.GeneratorBehaviour

  alias ResuMate.GeneratorError

  defmodule MarkdownSection do
    defstruct [:name, :heading, :contents]

    @type t :: %__MODULE__{
      name: atom(),
      heading: String.t() | nil,
      contents: String.t()
    }

    def new(name, heading, contents) do
      %__MODULE__{name: name, heading: heading, contents: contents}
    end
  end

  @impl true
  def generate(resume_data) do
    case content_for(resume_data) do
      content when is_binary(content) -> {:ok, content}
      errors -> {:error, errors}
    end
  end

  def content_for(resume_data) do
    sections = [
      build_section(:name, nil, resume_data),
      build_section(:contact_info, "### Contact Info", resume_data),
      # build_section(:name, nil, section_content(:name, resume_data)),
      # build_section(:contact_info, "### Contact Info", section_content(:contact_info, resume_data)),
      # ...
    ]

    sections_with_errors = Enum.filter(sections, fn {k, v} -> k == :error end)

    if Enum.any?(sections_with_errors) do
      sections_with_errors
      |> Enum.map(fn {_, v} -> v end)
      |> aggregate_errors()
    else
      sections
      |> Enum.reduce("", fn {:ok, markdown_section}, acc ->
        content = 
          if markdown_section.heading do
            "\n#{markdown_section.heading}\n#{markdown_section.contents}"
          else
            markdown_section.contents
          end

        acc <> content
      end)
    end
  end

  def section_content(:name, %{"name" => name_data}) do
    %{"first" => first, "last" => last} = name_data

    content = "# #{first} #{last}"

    {:ok, content}
  end

  def section_content(:contact_info, %{"contact_info" => contact_info_data}) do
    %{
      "email" => email, 
      "location" => %{"city" => city, "state" => state},
      "phone" => phone, 
      "site" => %{"text" => site_text, "url" => site_url}
    } = contact_info_data

    content = 
      """
      #{phone}
      #{city}, #{state}
      [#{email}]("mailto:#{email}")
      [#{site_text}](#{site_url})
      """

    {:ok, content}
  end

  # default to dummy string for unhandled section args ^_^
  def section_content(section, data) do 
    {:error, section_error_for(section, data)}
  end

  defp build_section(section_name, section_heading, resume_data) do
    case section_content(section_name, resume_data) do
      {:ok, contents} -> 
        {:ok, MarkdownSection.new(section_name, section_heading, contents)}
      err_tup -> 
        err_tup
    end
  end


  defp to_month_and_year(date) do
    Calendar.strftime(date, "%b, %Y")
  end

  defp section_error_for(section, _data) do
    %GeneratorError{message: "unable to generate content for section #{section}"}
  end

  defp aggregate_errors(list_of_errors) do
    error_message = list_of_errors
                    |> Enum.map(& &1.message)
                    |> Enum.join("\n")

    %GeneratorError{message: error_message}
  end
end
