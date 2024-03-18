local utils = require "utils"

return function()
  -- Documentation:
  -- @raycast.description Create beautiful images of your code with https://ray.so
  -- @raycast.author Thomas Paul Mann
  -- @raycast.authorURL https://github.com/thomaspaulmann

  -- Customization:
  -- Set colors. Available options: candy, breeze, midnight or sunset
  local COLORS = "midnight"
  -- Toggle background. Available options: true or false
  local BACKGROUND = "true"
  -- Toggle dark mode. Available options: true or false
  local DARK_MODE = "true"
  -- Set padding. Available options: 16, 32, 64 or 128
  local PADDING = "64"
  -- Set language. Available options: shell, cpp (C/C++), csharp, clojure, coffeescript, crystal, css, d, dart, diff, dockerfile, elm, erlang, fortran, gherkin,
  -- go, groovy, haskell, xml, java, javascript, json, jsx, julia, kotlin, latex, lisp, lua, markdown, mathematica, octave, nginx, objectivec, ocaml (F#), perl, php,
  -- powershell, python, r, ruby, rust, scala, smalltalk, sql, swift, typescript, (for Tsx, use jsx), twig, verilog, vhdl, xquery, yaml
  local LANGUAGE = "auto"

  -- Main:

  -- local TITLE = arg[1] or "Untitled-1"
  local TITLE = "Untitled-1"

  local no_selection_found_message = 'A text must be selected to encode it.'

  local selection = utils.get_visually_selected_text(no_selection_found_message)

  -- Urlencode any + symbols in the base64 encoded string
  CODE = utils.url_encode(utils.base64_encode(selection))

  vim.fn.system(
    "open 'https://ray.so/#code=" .. CODE .. "?colors=" .. COLORS .."&background="..BACKGROUND.."&darkMode="..DARK_MODE.."&padding="..PADDING.."&title="..TITLE.."&language="..LANGUAGE.. "'"
  )
end

