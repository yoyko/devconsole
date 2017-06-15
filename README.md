NuVo devconsole
===============

Web-based NuVo developer console.

## Development setup

Unfortunately we need a custom fork of elm-lang/websocket (because of the
`onOpen`/`onClose` events) and thus we have to use `elm-install` instead of
`elm-package`.

```sh
sudo apt-get install nodejs
npm install -g elm
npm install -g elm-github-install
elm-install
```

Also `elm-install` has to be manually re-run when dependencies change / are
not yet built, otherwise `elm-make` and `elm-reactor` will automatically
call `elm-package` which will mess it up.

## Dev server

Elm provides a development web server, just run:

```sh
elm-install
elm reactor
```

Then open http://localhost:8000/src/DevConsole.elm

## Release build

Either run `elm-make` directly:

```sh
elm-install
elm make --yes src/DevConsole.elm  --output=build/index.htm
```

or just run:

```sh
make
```
