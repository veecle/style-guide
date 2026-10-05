# Rust

Generally it's recommended to follow the [Rust API Guidelines].

[Rust API Guidelines]:https://rust-lang.github.io/api-guidelines/about.html

## Module hierarchy

Using `mod.rs` files is preferred to the `directory.rs` hierarchy schema.

`mod.rs` hierarchy:
```
foo/
    bar.rs
    mod.rs
```
`directory.rs` hierarchy:
```
foo/
    bar.rs
foo.rs
```
Directories containing only a `mod.rs` file should be not be used.

## Doc comments
Please refer to the [Rust standard library documentation convention].

Since documentation cannot be verified by the compiler, doctests are an important part of documentation.
They enforce adapting documentation in sync with the code.

[Rust standard library documentation convention]: https://github.com/rust-lang/rfcs/blob/0044bb7a438a19870d6932ee1de071d38e763b53/text/1574-more-api-documentation-conventions.md#appendix-a-full-conventions-text

Also see the [general Markdown guidelines](./markdown.md).

## Safety comments

All unsafe code should have an attached safety comment describing why it is safe within the context.
This is enforced via the [`clippy::undocumented_unsafe_blocks`](https://rust-lang.github.io/rust-clippy/master/index.html#undocumented_unsafe_blocks) lint.
The `SAFETY:` prefix should be all-caps, but this is not checked by the lint.

Related are `# Safety` sections mentioned in the above documentation convention, these should be applied to functions that are unsafe-to-call, describing what pre-conditions must be followed to make calling the API safe.

### Panic and error messages

>The error message given by the Display representation of an error type should be lowercase without trailing punctuation, and typically concise.
>
>—<https://rust-lang.github.io/api-guidelines/interoperability.html#error-types-are-meaningful-and-well-behaved-c-good-err>

For consistency within our codebase and with the Rust API guidelines, all error and panic messages should follow the Rust API guidelines.

### Bounds

Rust allows specifying bounds inline (`impl <T: Foo> Bar<T>`) and via `where` (`impl <T> Bar<T> where T: Foo`).
Using inline notation does not scale very well beyond anything other than trivial cases:

```rust
fn foo<A: Sized, B: Serialize + Deserialize, C: Sized + 'static>(_: A, _: B, _: C) {
    //...
}

// vs

fn foo<A, B, C>(_: A, _: B, _: C)
where
    A: Sized,
    B: Serialize + Deserialize,
    C: Sized + 'static
{
    //...
}

```

Objectively deciding what constitutes "trivial" is impossible, thus `where` notation should be used for any bounds.

## Workspace layout

Never use a non-virtual workspace; use either a virtual workspace or a standalone crate.
Separating the workspace-level config from the root crate makes reviewing changes clearer, and avoids the surprising default `default-members` behavior.
Unless it is obvious from the start that a repository will never have more than one crate in it, start with a virtual workspace containing a single member crate in a subdirectory.

## Dependencies

All dependencies should be specified at the workspace level with `default-features = false`, then referenced via `workspace = true` in crates.
If we do want the `default` feature in a dependency, that should be explicitly enabled in the `features` list so we consistently use `default-features = false`.
For a standalone crate, apply the same rules directly in `[dependencies]`.

```toml
# Virtual workspace
[workspace.dependencies]
awesome = { version = "0.0.0", default-features = false }
eepy = { version = "0.0.0", default-features = false }
```

```toml
# Standalone crate
[dependencies]
awesome = { version = "0.0.0", default-features = false, features = ["default", "secure-password", "civet"] }
eepy = { version = "0.0.0", default-features = false }
```

### Library workspace

For a workspace that publishes multiple libraries for external use, all required features should be applied at the crate level so each published crate only enables what it needs.
This includes workspaces that publish libraries but also have some published or internal binaries.

For consistency, we use the inline-table syntax whether there are features or not:

```toml
[dependencies]
awesome = { workspace = true, features = ["default", "secure-password", "civet"] }
eepy = { workspace = true }
```

### Binary workspace

For a workspace that produces binaries, where library crates are only used internally, all normally required features should be specified at the workspace level.
Dev-only features should remain per-crate so they don't leak into the final binaries.
On nightly (or once stabilized), set [`resolver.feature-unification = "workspace"`][feature-unification] in the `.cargo/config.toml`.
This minimizes rebuilds when building subsets of the workspace.

Since most entries are only `workspace = true`, use the dotted-key form for those and the inline-table form when adding features.

```toml
[workspace.dependencies]
awesome = { version = "0.0.0", default-features = false, features = ["default", "secure-password", "civet"] }
eepy = { version = "0.0.0", default-features = false }
```

```toml
[dependencies]
awesome.workspace = true

[dev-dependencies]
awesome = { workspace = true, features = ["test-utils"] }
eepy.workspace = true
```

[feature-unification]: https://doc.rust-lang.org/cargo/reference/unstable.html#feature-unification
