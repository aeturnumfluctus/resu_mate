# ResuMate

A little tool to generate a resume from structured data.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `resu_mate` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:resu_mate, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/resu_mate>.

## Usage

To generate a markdown-formatted resume named `resume.md` from existing data in 
`resume.yml`, open up an `iex` shell and run:

```elixir
iex> ResuMate.generate_resume(as: "resume.md", from: "resume.yml")
```

Currently, resume source files must adhere to a fairly specific structure in
order for the generator to function properly. An example of this structure can 
be found in an [examples file](examples/frodo_resume_data.yml) included in this
repository.

## License

Copyright 2022 Joshua Adams

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

