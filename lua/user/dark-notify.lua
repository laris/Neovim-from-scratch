----- keymap
--nmap <f5> :lua require('dark_notify').toggle()<cr>
---- Additional options
local dn = require('dark_notify')

-- Configure
dn.run({
    schemes = {
      -- you can use a different colorscheme for each
      dark  = "dark colorscheme name",
      -- even a different `set background=light/dark` setting or lightline theme
      -- if you use lightline, you may want to configure lightline themes,
      -- even if they're the same one, especially if the theme reacts to :set bg
      light = {
        colorscheme = "light scheme name",
        background = "override to either light or dark",
        lightline = "set your lightline theme name here"
      }
    },
    lightline_loaders = {
        -- It's tricky to get lightline to update a colorscheme for `set bg=dark`.
        -- Add a line here to reload the config for your lightline theme.
        my_ll_theme_name = "path to a lightline autoload file",
        -- example
        github = (vim.g.plug_home .. "/vim-colors-github/autoload/lightline/colorscheme/github.vim")
    },
    onchange = function(mode)
        -- optional, you can configure your own things to react to changes.
        -- this is called at startup and every time dark mode is switched,
        -- either via the OS, or because you manually set/toggled the mode.
        -- mode is either "light" or "dark"
    end,
})

-- Draw the blinds for now
dn.set_mode("dark")

-- Swap to whatever it isn't currently
dn.toggle()

-- Match the system
dn.update()

-- Stop reacting to changes
dn.stop()

-- Start reacting again, with previous settings
dn.run()
