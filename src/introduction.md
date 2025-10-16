# Style guide

For consistent and maintainable code, please follow this style guide.

A lot of things are not mentioned here, either because nobody wrote them down yet or because they have not come up yet.
This is a living document, please feel free to add to it.

## Naming

### Abbreviation

Abbreviations should be avoided.
Abbreviated names require the surrounding context for developers to infer their meaning.
While people working on the code will be familiar with the abbreviations, they will be foreign to new contributors.
Depending on people's background and experiences, the same abbreviations might mean different things to them.
Similarly, the same word will be abbreviated differently by different developers (e.g. `cxt`, `ctxt`, `c` for `context`).

The following example shows the readability difference for abbreviated and non-abbreviated code.

```rust
p.iter().for_each(|p| p.render(rt, r, cm, size));

e.iter()
    .filter_map(|e| icons.get(&e))
    .for_each(|i| i.render(rt, r, cm, size));
```

```rust
particles
    .iter()
    .for_each(|particle| particle.render(render_target, renderer, camera, window_size));

entities
    .iter()
    .filter_map(|entity| icons.get(&entity))
    .for_each(|icon| icon.render(render_target, renderer, camera, window_size));
```

While the first snippet requires a lot of domain knowledge or context from the surrounding code, the second snippet conveys a lot more information.

Domain specific naming can be an exception.
It should be accompanied by an explanatory comment for people not familiar with the specific domain.

### Ambiguity

Names should be as concise as possible without losing information.
Deciding what information needs to be preserved in a name is hard and varies depending on what is being named and where.
While a variable named `index` might be fine for a for-loop, it is not adequate for a global variable.

Single character variable names should always be avoided, in favor of more expressive naming (e.g. `source_buffer_index` instead of `i`).

When writing code, also take into account how it can be used out of the current context.
It should still convey a clear meaning.
The following example demonstrates how a macro defining some memory can not carry the required information without context:
```rust
// With context, it's clear this means megabytes.
const MEMORY_SIZE: u64 = MB!(1024);

// Without context, it's not clear whether this is megabytes, master-boot or maybe something entirely different.
confirm_firmware_header(MB!(2));
```

To avoid higher maintenance burdens, it is advisable to name everything expressively from the get-go.

### Consistency

Keeping variable/function/parameter naming consistent reduces the cognitive load on developers and users of libraries.
Code reuse is easier and more seamless with a uniform naming and parameter schema.
New users can orient themselves on repeating patterns within a consistent code-base.

## Spacing

Empty space is an important factor for code clarity.
Please use it to split logical units.
The following code snippets show how two empty lines can improve clarity and logical segmentation.

No empty space:
```rust
if -1 == !0 {
    if foo && foo || foo && foo {
        here_are_some_function_calls();
    }
} else if -2 == 10 {
    here_are_some_function_calls();
}
if other == bar {
    here_are_some_function_calls();
}
here_are_some_function_calls();
```
With empty space:
```rust
if -1 == !0 {
    if foo && foo || foo && foo {
        here_are_some_function_calls();
    }
} else if -2 == 10 {
    here_are_some_function_calls();
}

if other == bar {
    here_are_some_function_calls();
}

here_are_some_function_calls();
```

No empty space:
```rust
let mut byte_stream = ByteStream::new(input_bytes);
let version = byte_stream.byte()?.try_into()?;
let input_format = Format::from_byte_stream(&mut byte_stream, version, settings)?;
let root_function = Function::from_byte_stream(&mut byte_stream, version, settings)?;
let mut byte_writer = ByteWriter::new(output_format);
byte_writer.slice(settings.output.binary_signature.as_bytes());
byte_writer.byte(LuaVersion::Lua51.into());
```

With empty space:
```rust
let mut byte_stream = ByteStream::new(input_bytes);

let version = byte_stream.byte()?.try_into()?;
let input_format = Format::from_byte_stream(&mut byte_stream, version, settings)?;
let root_function = Function::from_byte_stream(&mut byte_stream, version, settings)?;

let mut byte_writer = ByteWriter::new(output_format);

byte_writer.slice(settings.output.binary_signature.as_bytes());
byte_writer.byte(LuaVersion::Lua51.into());
```

The second example showcases how empty space can be used to separate the four distinct logical steps within the function.

## Comments

Writing good documentation is at least as hard as writing good code, but it is paramount for maintainable code.
It should enable people to understand, maintain and work on code without having to rely on the original author.
Following English grammar, spelling and punctuation rules is important to avoid confusion and misunderstandings.

### Inline comments

Inline comments should explain reasoning that cannot be expressed in code.
One example could be `// We do X because Y is blocked by a bug [link to bug].`
Adding redundant information like `// Printing to output.` before a print statement does not only not add anything, but might lead to confusion if the following code is changed down the line without addressing the comment.
One exception is adding additional information to seemingly inconsequential code.

### Commented out code

Code that has been commented out is not checked by tests or the compiler.
Maintaining and keeping it up-to-date with changes is hard and easily forgotten.
As such, it is best to not leave any commented out code in PRs.

## Text files

Text files (including source code) should end with a trailing newline.
Many tools assume files follow this convention (such as GitHub, which displays a warning when files do not end with a newline).
The trailing newline also makes concatenating files work properly, and can reduce diffs.

You can configure most text editors to help adhere to this convention.
Consider configuring projects with [EditorConfig](https://editorconfig.org/) to help adhere to this convention automatically.
[`editorconfig-checker`](https://github.com/editorconfig-checker/editorconfig-checker) can be useful in CI to validate this.

## Scripts

Shells have evolved organically with little standardization.
Different systems have different shells with different versions and writing shell scripts that work reliably on all systems is hard.
However, shell scripting is often the most convenient option to implement small functionality (for example, in workflows for GitHub Actions).

Avoid long shell scripts or scripts that use features that you are not sure that are portable across different shells.

This document provides only basic guidelines intentionally.
When writing a shell script, if you keep thinking about these guidelines, then consider writing the script in a different language.

### Always use at least `set -e` so that shell scripts fail if any statement fails

```bash
#!/bin/sh

/does/not/exist
echo "finished"
```

Unless you use `set -e`, running this script in CI succeeds even though `/does/not/exist` does not execute.

(The process-spawning functions in most language standard libraries have a similar issue.
Try to ensure that failures in spawned processes halt execution by default.)

(`set -u` also makes scripts fail when accessing undefined variables.)

### Consider using the `#!/bin/sh` shebang.

`/bin/sh` might not be present on some systems, and corresponds to different shells on different systems, such as `dash` in Debian or `bash` in Fedora.
But so far, we have not encountered systems where `/bin/sh` is not a reasonable shell.

### Use alternative systems to test for portability

[Chimera Linux](https://chimera-linux.org/) is a Linux operating system with core tools from FreeBSD.
If your shell script works on Chimera Linux, then the script is more likely work on macOS.

You can adapt the following command to start a Chimera Linux container:

```
podman run -it --rm -v $(pwd):/pwd -w /pwd docker.io/chimeralinux/chimera
```

## Containers

Use always fully-qualified image names.
For example, use `docker.io/rust:latest` instead of `rust:latest`.

In most cases, Podman does not default to the pulling from Docker Hub, using fully-qualified names avoids prompts and errors.
Additionally, image provenance is more explicit.
