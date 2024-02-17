# redwood

redwood provides a ruby api for running queries against the cedar policy engine.

or, it might one day.

## building

the easiest way to build redwood is directly via rake from the nix devshell.

```bash
nix develop
bundle exec rake compile
```

without the devshell, you'll need to have cargo, ruby and libclang available
locally. (there might be other requirements, i'm not 100% certain).

## testing

currently all tests are written in ruby.

```bash
bundle exec rake test
```
