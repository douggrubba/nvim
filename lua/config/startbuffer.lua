local weather_line_idx = 3

local function set_buffer_lines(buf, lines)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
end

local function update_line(buf, idx, text)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, idx, idx + 1, false, { text })
	vim.bo[buf].modifiable = false
end

local function fetch_weather(buf)
	if vim.fn.executable("curl") ~= 1 then
		update_line(buf, weather_line_idx, "Huntersville weather: curl not found")
		return
	end

	local job = vim.fn.jobstart({ "curl", "-fsSL", "https://wttr.in/Huntersville?format=%C+%t" }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			for _, line in ipairs(data) do
				if line and line ~= "" then
					update_line(buf, weather_line_idx, "Huntersville weather: " .. vim.trim(line))
					return
				end
			end
		end,
		on_stderr = function(_, data)
			for _, line in ipairs(data) do
				if line and vim.trim(line) ~= "" then
					update_line(buf, weather_line_idx, "Huntersville weather: unavailable")
					return
				end
			end
		end,
		on_exit = function(_, code)
			if code ~= 0 then
				update_line(buf, weather_line_idx, "Huntersville weather: unavailable")
			end
		end,
	})

	if job <= 0 then
		update_line(buf, weather_line_idx, "Huntersville weather: unavailable")
	end
end

local function open_start_buffer()
	local buf = vim.api.nvim_create_buf(false, true)
	local lines = {
		"Welcome to Neovim",
		"",
		"Current time: " .. os.date("%A, %B %d %I:%M %p"),
		"Huntersville weather: loading...",
		"",
		"Use <leader>o to toggle the Oil sidebar and start navigating.",
	}
	set_buffer_lines(buf, lines)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = false
	vim.api.nvim_set_current_buf(buf)
	fetch_weather(buf)
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local argc = vim.fn.argc()
		if argc > 0 then
			for i = 0, argc - 1 do
				if vim.fn.isdirectory(vim.fn.argv(i)) == 0 then
					return
				end
			end
		end
		local current_buf = vim.api.nvim_get_current_buf()
		local bufname = vim.api.nvim_buf_get_name(current_buf)
		if bufname ~= "" and vim.fn.isdirectory(bufname) == 0 then
			return
		end
		open_start_buffer()
	end,
})
