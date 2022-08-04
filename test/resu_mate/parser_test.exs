defmodule ResuMate.ParserTest do
  use ExUnit.Case
  doctest ResuMate

  alias ResuMate.Parser

  describe "call/1" do
    test "success: it works" do
      resume_file = Path.expand("test_resumes/success/simple.yml")
      assert {:ok, parsed_data} = Parser.parse(resume_file)

      # dummy test for now
      assert parsed_data =~ resume_file
    end

    # test "error: it fails" #TODO
  end
end
