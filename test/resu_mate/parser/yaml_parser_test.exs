defmodule ResuMate.Parser.YamlParserTest do
  use ExUnit.Case
  doctest ResuMate.Parser.YamlParser

  alias ResuMate.ParserError
  alias ResuMate.Parser.YamlParser
  alias ResuMate.Factory

  setup do
    first_name = Factory.first_name()
    last_name = Factory.last_name()

    tmp_dir = Path.join(System.tmp_dir(), "test/_tmp")
    File.mkdir_p!(tmp_dir)
    filename = Path.join(tmp_dir, "resume.yml")

    File.open(filename, [:write], fn file ->
      yaml = 
        """
        name: 
          first: #{first_name}
          last: #{last_name}
        """
      
      IO.write(file, yaml)
    end)

    on_exit(fn -> File.rm(filename) end)

    %{filename: filename, first_name: first_name, last_name: last_name}
  end

  describe "parse/1" do
    test "success: returns a success tuple containing the parsed yaml data", %{
      filename: resume_file,
      first_name: first_name,
      last_name: last_name
    } do
      assert {:ok, data} = YamlParser.parse(resume_file)
      assert %{
        "name" => %{
          "first" => ^first_name, 
          "last" => ^last_name
        }
      } = data
    end

    test "error: returns an error tuple if parsing of file isn't successful" do
      assert {:error, error} = YamlParser.parse("nonsense")
      %ParserError{message: message} = error

      assert message =~ "Failed"
    end
  end
end
