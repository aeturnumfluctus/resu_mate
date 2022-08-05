defmodule ResuMate.GeneratorTest do
  use ExUnit.Case
  doctest ResuMate

  alias ResuMate.Generator

  import Mox

  setup :verify_on_exit!

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

  describe "generate/1" do
    test "success: it returns a success tuple w/ result yielded by the generator adapter", %{
      resume_data: resume_data,
      destination_filename: destination_filename
    } do
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

      assert {:ok, generated_filepath} = Generator.generate(destination_filename, resume_data)
      assert generated_filepath == destination_filename
    end

    test "error: returns an error tuple if generator adapter fails", %{
      resume_data: resume_data,
      destination_filename: destination_filename
    } do
      expect(ResuMate.MockGenerator, :generate, fn args ->
        assert args == resume_data

        {:error, %ResuMate.GeneratorError{message: "uh oh"}}
      end)

      assert {:error, generator_error} = Generator.generate(destination_filename, resume_data)
      assert %ResuMate.GeneratorError{message: "uh oh"} == generator_error
    end
  end
end
