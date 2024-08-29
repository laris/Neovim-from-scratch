function check_cargo_play()
  -- Check if 'cargo' is available in the system
  local cargo_exists = vim.fn.executable('cargo') > 0
  --vim.api.nvim_out_write("cargo_exists=" .. tostring(cargo_exists) .. "\n")
  if cargo_exists then
    -- Check if 'cargo play --version' is available
    local cargo_play_command = 'cargo play --version'
    local cargo_play_status = vim.fn.system(cargo_play_command)
    -- Check the return value directly
    --vim.api.nvim_out_write("cargo_play_status=" .. tostring(cargo_play_status) .. "\n")
    if vim.v.shell_error == 0 then
      -- 'cargo play --version' executed successfully, proceed with your logic
      --vim.api.nvim_out_write("cargo play is installed and available.\n")
      return "cargo play is installed and available."
    else
      -- 'cargo play --version' failed, 'cargo play' is not installed
      local error_msg = "cargo play is not installed or encountered an error. \
                        Error message: " .. tostring(cargo_play_status)
      vim.api.nvim_out_write(error_msg .. "\n")
      error(error_msg)
    end
  else
    -- 'cargo' is not installed, handle the case where 'cargo' is not available
    vim.api.nvim_out_write("cargo is not installed.\n")
    error("cargo is not installed.")
  end
end

function is_rust_file() -- bug, don't know why return empty value
  -- Get the file type of the current buffer
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  --vim.api.nvim_out_write("filetype: " .. filetype .. "\n")
  -- Check if the file type is 'rust'
  if filetype == "rust" then
    return "rust"
  else 
    error("Current open filetype: " .. filetype)
  end
end
-- -- check cargo play firstly, then check file type
-- local st_cargo, msg_cargo = pcall(check_cargo_play)
-- local st_rust_file, msg_rust_file = pcall(is_rust_file)
-- --local st_rust_file, msg_rust_file = true, "fake rust true"
-- --vim.api.nvim_out_write("pcall: st_rust_file=" ..  tostring(st_rust_file) .. "\n" .. msg_rust_file .. "\n")
-- if st_cargo and st_rust_file then
--   -- if cargo play works, set CargoPlay as com
--   --vim.api.nvim_out_write(msg .. "\n")
--   vim.cmd("command! CargoPlay !cargo play %")
-- else
--   vim.api.nvim_out_write("Error: " .. msg_cargo .. msg_rust_file .. "\n")
--   return
-- end

--vim.cmd([[ command! CargoPlay lua require('mycommands').cargo_play() ]])

--M = {}
----M.cargo_play()
--function M.cargo_play()
--------------------------------------------------------------------------------
function split_args(arg_string)
  local args = {}
  local pattern = '%S+'
  for arg in string.gmatch(arg_string, pattern) do
    table.insert(args, arg)
  end
  return args
end

function cargo_play(...)
  local arg_string = table.concat({...}, " ")
  local args = split_args(arg_string)
  local cargo_play_args_flags_options = {}
  local args_pass_into_program = {}
  local current_file = vim.fn.expand('%:p')
  local split_index = nil

  -- Find the index of "--" if it exists
  for i, arg in ipairs(args) do
    --vim.api.nvim_out_write("debug: arg["..i.."]='"..tostring(arg).."'\n")
    if arg == "--" then
      split_index = i
     --vim.api.nvim_out_write("debug: split_index="..i.."\n")
      break
    end
  end

  -- Split args into cargo_play_args_flags_options and args_pass_into_program
  if split_index then
    for i = 1, split_index - 1 do
      table.insert(cargo_play_args_flags_options, args[i])
    end
    for i = split_index + 1, #args do
      table.insert(args_pass_into_program, args[i])
    end

     -- cargo_play_args_flags_options
  --local debug_output = "debug: cargo_play_args_flags_options={"
  --for k, v in ipairs(cargo_play_args_flags_options) do
  --  debug_output = debug_output .. tostring(v) .. " "
  --end
  --debug_output = debug_output .. "}\n"
  --vim.api.nvim_out_write(debug_output)
  
  -- args_pass_into_program
  --local debug_output = "debug: args_pass_into_program={"
  --for k, v in ipairs(args_pass_into_program) do
  --  debug_output = debug_output .. tostring(v) .. " "
  --end
  --debug_output = debug_output .. "}\n"
  --vim.api.nvim_out_write(debug_output)

  else
    -- If no "--" is found, all args go to cargo_play_args_flags_options
    cargo_play_args_flags_options = args
  end

  -- Construct the command
  local cargo_play_args = table.concat(cargo_play_args_flags_options, ' ')
  --vim.api.nvim_out_write("debug: cargo_play_args="..cargo_play_args.."\n")
  local program_args = table.concat(args_pass_into_program, ' ')
  --vim.api.nvim_out_write("debug: args_pass_into_program="..program_args.."\n")
--  vim.api.nvim_out_write("debug: ".."cargo_play_args="..cargo_play_args.."current_file="..current_file.."program_args="..program_args.."\n")

  local command
  if #args_pass_into_program > 0 then
    command = string.format('cargo play %s %s -- %s', cargo_play_args, current_file, program_args)
  else
    command = string.format('cargo play %s %s', cargo_play_args, current_file)
  end

  -- Run the cargo play command and capture the output in a list
  local output = vim.fn.systemlist(command)

  -- Display the output in the bottom minibuffer
  for _, line in ipairs(output) do
    vim.api.nvim_out_write(line .. "\n")
  end
end
--------------------------------------------------------------------------------
--| function cargo_play(...)
--|   local args = {...}
--|   local args_string = table.concat(args, ' ')
--|   local current_file = vim.fn.expand('%:p')
--|   local command = string.format('cargo play %s %s', args_string, current_file)
--|   --vim.api.nvim_out_write("debug: "..current_file.."--"..command.."\n")
--|   --vim.fn.system(command)
--|   --vim.cmd("silent execute '!" .. command .. "'")
--|   --vim.cmd("silent! read ! " .. command)
--|   -- Run the cargo play command and capture the output in a list
--|   local output = vim.fn.systemlist(command)
--| --------------------------------------------------------------------------------
--|   -- Display the output in the bottom minibuffer
--|   for _, line in ipairs(output) do
--|     vim.api.nvim_out_write(line .. "\n")
--|   end
--------------------------------------------------------------------------------
--    -- Create a new buffer for displaying the output
--  local output_buffer = vim.api.nvim_create_buf(false, true)
--  -- Set the output buffer as the current buffer
--  vim.api.nvim_set_current_buf(output_buffer)
--  -- Display the output in the new buffer
--  for _, line in ipairs(output) do
--    vim.api.nvim_buf_set_lines(output_buffer, -1, -1, false, {line})
--  end
--  -- Open a new split window for the output buffer below the current window
--  vim.cmd('split')
--------------------------------------------------------------------------------
--  -- Save the current window and cursor position
--  local original_window = vim.fn.winnr()
--  local original_cursor = vim.fn.getpos('.')
--
--  -- Run the cargo play command and capture the output in a list
--  local output = vim.fn.systemlist(command)
--
--  -- Create a new buffer for displaying the output
--  local output_buffer = vim.api.nvim_create_buf(false, true)
--
--  -- Set the output buffer as the current buffer
--  vim.api.nvim_set_current_buf(output_buffer)
--
--  -- Display the output in the new buffer
--  for _, line in ipairs(output) do
--    vim.api.nvim_buf_set_lines(output_buffer, -1, -1, false, {line})
--  end
--
--  -- Open a new split window for the output buffer below the current window
--  vim.cmd('split')
--
--  -- Restore the original window and cursor position
--  vim.fn.win_gotoid(original_window)
--  vim.fn.setpos('.', original_cursor)
 --------------------------------------------------------------------------------
--end
--return M

function checked_cargo_play(...)
  local args = {...}
  -- Convert the table of arguments to a string with spaces
  local args_string = table.concat(args, ' ')
  -- Now args_string contains all the arguments separated by spaces
  --vim.api.nvim_out_write("args="..args_string.."\n")
  local status_cargo, msg_cargo = pcall(check_cargo_play)
  local status_rust_file, msg_rust_file = pcall(is_rust_file)
  if status_cargo and status_rust_file then
    cargo_play(args_string)
    return
  else
    vim.api.nvim_out_write("Error: need both `cargo play` and `rust` file:\ncargo play status: " .. msg_cargo .."\nCurrent file type: ".. msg_rust_file .. "\n")
    return
  end
end

--vim.cmd("command! -nargs=0 CargoPlay call s:checked_cargo_play()")
--vim.cmd("command! -nargs=0 CargoPlay lua checked_cargo_play()")
vim.cmd("command! -nargs=* CargoPlay lua checked_cargo_play(<f-args>)")
--local keymap = vim.api.nvim_set_keymap
--local opts = { noremap = true, silent = true }

--swapbuffers.setup({
--  ignore_filetypes = {'NvimTree'},
--})

-- keymap
--keymap("n", "<C-c>r", vim.cmd [[!cargo play %]], opts)

