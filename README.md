NuVo devconsole
===============

Web-based NuVo developer console.

## Development setup

```sh
sudo apt-get install nodejs
npm install -g elm
```

## Dev server

Elm provides a development web server, just run:

```sh
elm reactor
```

Then open http://localhost:8000/src/DevConsole.elm

## Release build

Either run `elm-make` directly:

```sh
elm make --yes src/DevConsole.elm  --output=build/index.htm
```

or just run:

```sh
make
```
