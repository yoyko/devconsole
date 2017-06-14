NuVo devconsole
===============

Web-based NuVo developer console.

## Development setup

```sh
sudo apt-get install nodejs
npm install -g elm
```

## Dev server

```sh
elm reactor
```

Then open http://localhost:8000/

## Release build

```sh
elm make --yes src/DevConsole.elm  --output=build/index.htm
```
