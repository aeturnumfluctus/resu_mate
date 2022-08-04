defmodule ResuMate.ParserTest do
  use ExUnit.Case
  doctest ResuMate

  alias ResuMate.Parser

  import Mox

  setup :verify_on_exit!

  @dummy_resume_contents %{
    "name" => %{
      "first" => "Bilbo",
      "last" => "Baggins"
    }
  }

  describe "parse/1" do
    test "success: it returns a success tuple w/ result yielded by the parser adapter" do
      resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == resume_file

        {:ok, @dummy_resume_contents}
      end)

      assert {:ok, _parsed_data} = Parser.parse(resume_file)
    end

    test "error: returns an error tuple if parser adapter fails" do
      resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == resume_file

        {:error, %ResuMate.ParserError{}}
      end)

      assert {:error, _parser_error} = Parser.parse(resume_file)
    end
  end
end
