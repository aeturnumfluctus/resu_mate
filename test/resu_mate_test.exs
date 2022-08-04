defmodule ResuMateTest do
  use ExUnit.Case
  doctest ResuMate

  describe "parse/1" do
    test "success: it works" do
      # resume_file = Path.expand("test_resumes/success/simple.yml")
      # assert {:ok, parsed_data} = ResuMate.parse(resume_file)

      # dummy test for now
      # assert parsed_data =~ resume_file
    end

    # test "error: it fails" #TODO
  end
end
