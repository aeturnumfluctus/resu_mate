defmodule ResuMate.Generator.MarkdownGeneratorTest do
  use ExUnit.Case
  doctest ResuMate.Generator.MarkdownGenerator

  alias ResuMate.GeneratorError
  alias ResuMate.Generator.MarkdownGenerator
  alias ResuMate.Factory

  describe "generate/1" do
    test "success: returns a success tuple containing the generated markdown file" do
      resume_data = %{
        "name" => %{
          "first" => "Bilbo",
          "last" => "Baggins"
        },
        "contact_info" => %{
          "phone" => "123-456-7890",
          "email" => "bagginsboi@ringbearer.net",
          "location" => %{
            "city" => "The Shire",
            "state" => "Middle Earth"
          },
          "site" => %{
            "text" => "https://ringbearer.net",
            "url" => "https://localhost:4000"
          }
        },
        "online_presence" => %{
          "linkedin" => "https://www.linkedin.com/in/frododododododododo",
          "github" => "https://github.com/frododododododododo"
        },
        "profile" => %{
          "blurb" => Factory.paragraph()
        },
        "education" => [
          %{
            "degree" => "BS",
            "focus" => %{
              "major" => "Metallurgy",
              "minor" => "Philosophy"
            },
            "location" => %{
              "city" => "Mordor",
              "state" => "Middle Earth"
            },
            "school" => "Mount Doom Institute of Technology",
            "start" => 2008,
            "end" => 2012,
          }
        ],
        "strengths" => [
          "Evading complex problems through wit & bravery",
          "Aptitude of hiking",
        ],
        "skills" => %{
          "proficiencies" => ["Elixir"],
          "familiarities" => ["Quantum Mechanics", "Cursed Jewelry"],
          "operating_systems" => ["Linux", "Mac OS X"],
        },
        "work_experience" => [
          %{
            "title" => "Ring Bearer",
            "company" => %{
              "name" => "The Fellowship LLC",
              "location" => %{
                "city" => "Rivendell",
                "state" => "Middle Earth"
              }
            },
            "start" => %{
              "year" => 2021,
              "month" => 4
            },
            "end" => %{
              "year" => 2022,
              "month" => 8
            },
            "duties_and_accomplishments" => [
              Factory.sentence(), 
              Factory.sentence(), 
              Factory.sentence(), 
            ]
          }
        ]
      }

      assert {:ok, resume_file} = MarkdownGenerator.generate(resume_data)
      assert_markdown_contains(resume_file, "Bilbo")
    end

    test "error: returns an error tuple if parsing of file isn't successful" do
      assert {:error, error} = MarkdownGenerator.generate("nonsense")
      %GeneratorError{message: message} = error

      assert message =~ "unable to generate"
    end
  end

  defp assert_markdown_contains(file, match_list) when is_list(match_list) do
    File.open(file, [:read], fn file ->
      for string_or_regex <- match_list do
        assert IO.read(file) =~ string_or_regex
      end
    end)
  end

  defp assert_markdown_contains(file, str) when is_binary(str) do
    assert_markdown_contains(file, [str])
  end

  defp assert_markdown_contains(file, %{__struct__: Regex} = regex) do
    assert_markdown_contains(file, [regex])
  end
end
