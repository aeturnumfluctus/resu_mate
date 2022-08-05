Application.ensure_all_started(:mox)

Application.put_env(:resu_mate, :generator, ResuMate.MockGenerator)
Application.put_env(:resu_mate, :parser, ResuMate.MockParser)

ExUnit.start()
Faker.start()
