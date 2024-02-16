# redwood

redwood provides a ruby api for running queries against the cedar policy engine.

or, it might one day.

## building

the easiest way to build redwood is with the nix flake.

```bash
nix build
```

the second easiest way to build redwood is directly via cargo from the nix
devshell.

```bash
nix develop
cargo build
```

you can probably also build redwood without nix.
