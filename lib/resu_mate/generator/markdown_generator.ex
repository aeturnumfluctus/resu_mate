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

    def to_text(%__MODULE__{heading: nil, contents: contents}), do: contents

    def to_text(%__MODULE__{heading: heading, contents: contents}) do
      "#{heading}\n#{contents}"
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
    sections = build_sections(resume_data)
    sections_with_errors = Enum.filter(sections, fn {k, _v} -> k == :error end)

    if Enum.any?(sections_with_errors) do
      sections_with_errors
      |> Enum.map(fn {_, error} -> error end)
      |> aggregate_errors()
    else
      sections
      |> Enum.map(fn {:ok, markdown_section} -> markdown_section end)
      |> Enum.map(&MarkdownSection.to_text/1)
      |> Enum.join("\n")
    end
  end

  defp build_sections(resume_data) do
    [
      build_section(:name, nil, resume_data),
      build_section(:contact_info, "## Contact Info", resume_data),
      build_section(:online_presence, nil, resume_data),
      build_section(:profile, "## Profile", resume_data),
      build_section(:education, "## Education", resume_data),
      build_section(:strengths, "## Strengths", resume_data),
      build_section(:skills, "## Skills", resume_data),
      build_section(:work_experience, "## Work Experience", resume_data)
    ]
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

    content = """
    \n#{phone}
    \n#{city}, #{state}
    \n[#{email}]("mailto:#{email}")
    \n[#{site_text}](#{site_url})
    """

    {:ok, content}
  end

  def section_content(:education, %{"education" => education_data}) do
    # too naive..
    sort_by_fn = fn %{"start" => start_year, "end" => end_year} ->
      {
        Date.new(end_year, 1, 1),
        Date.new(start_year, 1, 1)
      }
    end

    content =
      education_data
      |> Enum.sort_by(&sort_by_fn.(&1), :desc)
      |> Enum.map(fn education_entry ->
        section_content(:education_entry, education_entry)
      end)
      |> Enum.join("\n")

    {:ok, content}
  end

  def section_content(:education_entry, education_entry) do
    %{
      "degree" => degree,
      "focus" => %{"major" => major, "minor" => minor},
      "location" => %{"city" => city, "state" => state},
      "school" => school,
      "start" => start_year,
      "end" => end_year
    } = education_entry

    """
    #{school}
    *#{city}, #{state}* | *#{start_year} - #{end_year}*
    #{degree} in #{major}
    Minor in #{minor}
    """
  end

  def section_content(:online_presence, %{"online_presence" => online_presence_data}) do
    %{
      "github" => github_url,
      "linkedin" => linkedin_url
    } = online_presence_data

    content = """
    \n[Github](#{github_url})
    \n[LinkedIn](#{linkedin_url})
    """

    {:ok, content}
  end

  def section_content(:profile, %{"profile" => %{"blurb" => blurb}}) do
    {:ok, blurb}
  end

  # TODO: this could be better.. ^_^
  def section_content(:skills, %{"skills" => skills_data}) do
    %{
      "familiarities" => familiarities,
      "operating_systems" => operating_systems,
      "proficiencies" => proficiencies
    } = skills_data

    content = """
    ### Languages & Frameworks
    - #{Enum.join(proficiencies, "\n- ")}
    - #{Enum.join(familiarities, "\n- ")}

    ### Operating Systems
    - #{Enum.join(operating_systems, "\n- ")}
    """

    {:ok, content}
  end

  # TODO: this could be better.. ^_^
  def section_content(:strengths, %{"strengths" => strengths_data}) do
    content = """
    - #{Enum.join(strengths_data, "\n- ")}
    """

    {:ok, content}
  end

  # TODO: this could be better.. ^_^
  def section_content(:work_experience, %{"work_experience" => work_experience_data}) do
    # reverse chronological order sort
    sort_by_fn = fn %{"start" => start_date, "end" => end_date} ->
      {
        Date.new(end_date["year"], end_date["month"], 1),
        Date.new(start_date["year"], start_date["month"], 1)
      }
    end

    content =
      work_experience_data
      |> Enum.sort_by(&sort_by_fn.(&1), :desc)
      |> Enum.map(fn work_experience_entry ->
        section_content(:work_experience_entry, work_experience_entry)
      end)
      |> Enum.join("\n")

    {:ok, content}
  end

  def section_content(:work_experience_entry, work_experience_entry) do
    %{
      "company" => %{"name" => company_name, "location" => company_loc},
      "duties_and_accomplishments" => duties_and_accomplishments,
      "start" => %{"year" => start_year, "month" => start_month},
      "end" => %{"year" => end_year, "month" => end_month},
      "title" => title
    } = work_experience_entry

    # use first day of month, since day doesn't matter..
    {:ok, start_date} = Date.new(start_year, start_month, 1)
    {:ok, end_date} = Date.new(end_year, end_month, 1)

    start_date_str = to_month_and_year(start_date)
    end_date_str = to_month_and_year(end_date)

    date_span = "#{start_date_str} - #{end_date_str}"

    """
    ### #{title}, #{company_name}, #{company_loc["city"]}, #{company_loc["state"]}
    *#{date_span}*
    - #{Enum.join(duties_and_accomplishments, "\n- ")}
    """
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
    error_message =
      list_of_errors
      |> Enum.map(& &1.message)
      |> Enum.join("\n")

    %GeneratorError{message: error_message}
  end
end
