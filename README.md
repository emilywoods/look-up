# Look up

Looking for the International Space Station: A small Gleam app to tell you when
to look up if you want to see the ISS.


## Quick start

```sh
# Build the project
rebar3 compile

# Run the eunit tests
rebar3 eunit

# Run the Erlang REPL
rebar3 shell
```

## When should I look up?

```sh

# Run the Erlang REPL
rebar3 shell

# Execute the following (inputting your own coordinates)
1> look_up:run(51.509865, -.118092).
Look up at 2020-06-28 02:54 +00:00 if you want to see the space station!
ok
```


## Installation

If [available in Hex](https://www.rebar3.org/docs/dependencies#section-declaring-dependencies)
this package can be installed by adding `look_up` to your `rebar.config` dependencies:

```erlang
{deps, [
    look_up
]}.
```
