# ResuMate

A little tool to generate a resume from structured data.

## Usage

To generate a markdown-formatted resume named `resume.md` from existing data in 
`resume.yml`, run the following `mix` task:

```elixir
$ mix resu_mate.gen.resume resume.md --source resume.yml 
```

Alternatively, you can open up an `iex` shell and run:

```elixir
iex> ResuMate.generate_resume(as: "resume.md", from: "resume.yml")
```

## Extensibility

`ResuMate` is designed to be malleable enough to, albeit with a little of 
tinkering, suit your individual needs / preferences. 

Currently, resume source files must adhere to a fairly specific structure in
order for the generator to function properly. An example of this structure can 
be found in an [example file](examples/frodo_resume_data.yml) included in this
repository. 

At some future point, the goal is for these existing structural constraints to 
be loosened a bit.

## Roadmap

- [x] Add a `Mix` task for generating resumes (thus bypassing the need to spin up an `iex`)
- [ ] Update Resume generation logic such that it's easier to generate resume's with varied underlying source data structures.
- [ ] Add more generator possibilities (e.g. html, pdf, ...) 

## License

Copyright (c) 2022 Joshua Adams

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

