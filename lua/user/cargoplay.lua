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
-- check cargo play firstly, then check file type
local st_cargo, msg_cargo = pcall(check_cargo_play)
--local st_rust_file, msg_rust_file = pcall(is_rust_file)
local st_rust_file, msg_rust_file = true, "fake rust true"
--vim.api.nvim_out_write("pcall: st_rust_file=" ..  tostring(st_rust_file) .. "\n" .. msg_rust_file .. "\n")
if st_cargo and st_rust_file then
  -- if cargo play works, set CargoPlay as com
  --vim.api.nvim_out_write(msg .. "\n")
  vim.cmd("command! CargoPlay !cargo play %")
else
  vim.api.nvim_out_write("Error: " .. msg_cargo .. msg_rust_file .. "\n")
  return
end

--vim.cmd([[ command! CargoPlay lua require('mycommands').cargo_play() ]])

--M = {}
----M.cargo_play()
--function M.cargo_play()
--  local current_file = vim.fn.expand('%:p')
--  local command = string.format('cargo play %s', current_file)
--  vim.api.nvim_out_write("debug: "..current_file.."--"..command.."\n")
--  vim.fn.system(command)
--  return "cargo_play"
--end
--return M

--local keymap = vim.api.nvim_set_keymap
--local opts = { noremap = true, silent = true }

--swapbuffers.setup({
--  ignore_filetypes = {'NvimTree'},
--})

-- keymap
--keymap("n", "<C-c>r", vim.cmd [[!cargo play %]], opts)

