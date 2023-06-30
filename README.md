# lua-gmod-lib
Библиотека функций из Garry's Mod для чистого Lua

- Установка: `luarocks install lua-gmod-lib`
- Использование: `require("gmod.timer")`, `require("gmod.http")` и тому подобное
- Поддержка: [Telegram чат](https://t.me/+662fzXsxLmM4ZGE6) гмодеров
- Если какой-то функции не хватает – смело делайте pull request
- Локальная разработка через редактирование [package.path](https://stackoverflow.com/questions/5761229/is-there-a-better-way-to-require-file-from-relative-path-in-lua) или env LUA_PATH
- Таймеры и http функции требуют бесконечного выполнения кода, так как создают [корутины](https://blog.amd-nick.me/understanding-lua-coroutines), которые диспетчит [copas](https://github.com/lunarmodules/copas). Если вы планируете делать `require("gmod.http")` или `require("gmod.timer")`, то вам необходимо вручную выполнить `luarocks install lua-requests-async` или `luarocks install copas` соответственно (они не включены в стандартные зависимости)
- Никакие функции не включаются в глобальный scope сами по себе. Это нужно делать вручную, например так:

```lua
timer = require("gmod.timer") -- сделает библиотеку timer доступной из любого файла скрипта без дополнительных require

-- или вот так:

local globals = require("gmod.globals") -- isstring, HTTP, PrintTable, etc
for name, value in pairs(globals) do
	_G[name] = value
end
```
