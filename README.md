## ๐ช React Rodux Game

This is a simple game template built with React and Rodux.

### โจ Features

- โ๏ธ React-based UI
- ๐ Rodux [hooks](src/client/providers/ReactRodux.lua), [side effects](src/shared/store/effects.lua), and [server-to-client syncing](src/server/store/middleware/serverToClientMiddleware.lua)
- ๐งฌ Useful global types & typeof functions
- ๐ Typed [Roselect library](src/shared/utils/roselect/)

### ๐ฆ Dependencies

- [Aftman](https://github.com/LPGhatguy/aftman) ยท Useful toolchain manager
- [Luau LSP](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.luau-lsp) ยท Language server for Luau
- [Rojo](https://marketplace.visualstudio.com/items?itemName=evaera.vscode-rojo) ยท Syncs files to Roblox Studio

### ๐ Getting Started

Install Aftman dependencies

```sh
aftman install
```

Install Wally packages

```sh
sh scripts/install.sh
```
