defmodule ResuMateTest do
  use ExUnit.Case
  doctest ResuMate

  alias ResuMate.{GeneratorError, ParserError}

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

      assert {:ok, _parsed_data} = ResuMate.parse(resume_file)
    end

    test "error: returns an error tuple if parser adapter fails" do
      resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == resume_file

        {:error, %ParserError{}}
      end)

      assert {:error, _parser_error} = ResuMate.parse(resume_file)
    end
  end

  describe "parse!/1" do
    test "success: it returns a success tuple w/ result yielded by the parser adapter" do
      resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == resume_file

        {:ok, @dummy_resume_contents}
      end)

      assert _parsed_data = ResuMate.parse!(resume_file)
    end

    test "error: returns an error tuple if parser adapter fails" do
      resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == resume_file

        {:error, %ParserError{}}
      end)

      assert_raise ParserError, fn -> ResuMate.parse!(resume_file) end
    end
  end

  describe "generate_resume/1" do
    setup do
      configured_generator = Application.get_env(:resu_mate, :generator)
      tmp_dir = Path.join(System.tmp_dir(), "test/_tmp")
      File.mkdir_p!(tmp_dir)
      destination_filename = Path.join(tmp_dir, "resume.yml")

      resume_data = %{
        "name" => %{
          "first" => "Bilbo",
          "last" => "Baggins"
        }
      }

      Application.put_env(:resu_mate, :generator, ResuMate.MockGenerator)

      on_exit(fn ->
        Application.put_env(:resu_mate, :generator, configured_generator)

        File.rm(destination_filename)
      end)

      %{destination_filename: destination_filename, resume_data: resume_data}
    end

    test "success: it returns a success tuple w/ result yielded by the generator", %{
      destination_filename: destination_filename,
      resume_data: resume_data
    } do
      source_resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == source_resume_file

        {:ok, resume_data}
      end)

      expect(ResuMate.MockGenerator, :generate, fn parsed_data ->
        assert parsed_data == resume_data

        %{
          "name" => %{
            "first" => first_name,
            "last" => last_name
          }
        } = parsed_data

        resume_content = "#{first_name} #{last_name}"

        {:ok, resume_content}
      end)

      assert {:ok, _generate_resumed_data} =
               ResuMate.generate_resume(
                 from: source_resume_file,
                 as: destination_filename
               )
    end

    test "error: returns an error tuple if the parser fails", %{
      destination_filename: destination_filename,
      resume_data: resume_data
    } do
      source_resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == source_resume_file

        {:error, %ParserError{}}
      end)

      assert {:error, generate_resume_error} =
               ResuMate.generate_resume(
                 from: source_resume_file,
                 as: destination_filename
               )

      assert %ParserError{} = generate_resume_error
    end

    test "error: returns an error tuple if the generator fails", %{
      destination_filename: destination_filename,
      resume_data: resume_data
    } do
      source_resume_file = "some_resume.yml"

      expect(ResuMate.MockParser, :parse, fn args ->
        assert args == source_resume_file

        {:ok, resume_data}
      end)

      expect(ResuMate.MockGenerator, :generate, fn args ->
        assert args == resume_data

        {:error, %ResuMate.GeneratorError{message: "uh oh"}}
      end)

      assert {:error, generate_resume_error} =
               ResuMate.generate_resume(
                 from: source_resume_file,
                 as: destination_filename
               )

      assert %GeneratorError{} = generate_resume_error
    end
  end
end
