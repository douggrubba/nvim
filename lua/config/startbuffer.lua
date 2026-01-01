local time_line_idx
local weather_line_idx
local start_ns = vim.api.nvim_create_namespace("startbuffer")
local git_status_lines = {}
local start_bufnr
local title_line_indices = {}

local title_ascii = [[

                     .--::--.                     
     :+*=:          =@@@@@@@@=          :+*+:     
    %@@@@@@%*=.     =@@@@@@@@-     .=*%@@@@@@#    
    @@@@@@@@@@@@#+-. .%@@@@#. .-+#@@@@@@@@@@@%    
    -@@@@@@@@@@@@@@@@*:#@@#:*@@@@@@@@@@@@@@@@-    
      :+*********####-%@%%@%-####********++.      
     .%@@@@@@@@@@@@@%:@@@@@@:@@@@@@@@@@@@@@%      
     .@@@@@@@@%*+-:   =@@@@=  .:-+*%@@@@@@@%.     
       =*+-:           ###*          .:-+*=       
                       %@@%                       
                       *@@*                       
                       +@@=                       
                       :##:                       
                       :@@:                       
                        @@                        
                        ..                        
]]

local title_lines = vim.split(title_ascii, "\n", { plain = true })

local function set_highlight_groups()
	vim.api.nvim_set_hl(0, "StartBufferTitle", { bold = true, italic = true })
	vim.api.nvim_set_hl(0, "StartBufferTime", { fg = "#e7c664", ctermfg = 178 })
	vim.api.nvim_set_hl(0, "StartBufferWeather", { fg = "#7aa2f7", ctermfg = 75 })
	vim.api.nvim_set_hl(0, "StartBufferGitClean", { fg = "#8ec07c", ctermfg = 120 })
	vim.api.nvim_set_hl(0, "StartBufferGitDirty", { fg = "#ff9e64", ctermfg = 209 })
end

set_highlight_groups()

local function apply_highlights(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf, start_ns, 0, -1)
	for _, idx in ipairs(title_line_indices) do
		vim.api.nvim_buf_add_highlight(buf, start_ns, "StartBufferTitle", idx, 0, -1)
	end
	if time_line_idx then
		vim.api.nvim_buf_add_highlight(buf, start_ns, "StartBufferTime", time_line_idx, 0, -1)
	end
	if weather_line_idx then
		vim.api.nvim_buf_add_highlight(buf, start_ns, "StartBufferWeather", weather_line_idx, 0, -1)
	end
	for idx, hl in pairs(git_status_lines) do
		if hl then
			vim.api.nvim_buf_add_highlight(buf, start_ns, hl, idx, 0, -1)
		end
	end
end

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
	apply_highlights(buf)
end

local function safe_is_empty(tbl)
	if type(tbl) ~= "table" then
		return true
	end
	return vim.tbl_isempty(tbl)
end

local function get_git_info_lines()
	local dir = vim.fn.getcwd()
	local info = {
		lines = {},
		status_start = nil,
		status_count = 0,
		highlight = nil,
	}
	if vim.fn.executable("git") ~= 1 then
		info.lines = {
			"The current directory is: " .. dir,
			"Git info: git executable not found",
		}
		return info
	end

	local inside_repo = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--is-inside-work-tree" })
	if vim.v.shell_error ~= 0 or not inside_repo or inside_repo[1] ~= "true" then
		info.lines = {
			"The current directory is: " .. dir,
			"Git info: not a git repository",
		}
		return info
	end

	local branch_output = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" })
	local branch = branch_output[1] and vim.trim(branch_output[1]) or "detached"
	if branch == "" or branch == "HEAD" then
		branch = "detached"
	end

	info.lines = {
		string.format("The current directory is: %s (%s)", dir, branch),
		"Git status:",
	}
	info.status_start = #info.lines

	local short_status = vim.fn.systemlist({ "git", "-C", dir, "status", "--short" })
	local short_ok = vim.v.shell_error == 0
	local is_clean = short_ok and safe_is_empty(short_status)

	local status_output = vim.fn.systemlist({ "git", "-C", dir, "status" })
	local status_ok = vim.v.shell_error == 0 and not safe_is_empty(status_output)
	if not status_ok then
		status_output = { "git status unavailable" }
		is_clean = false
	end

	for _, line in ipairs(status_output) do
		table.insert(info.lines, "  " .. line)
	end

	info.status_count = #status_output
	if info.status_count > 0 then
		info.highlight = is_clean and "StartBufferGitClean" or "StartBufferGitDirty"
	end
	return info
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
	local lines = {}
	title_line_indices = {}
	for _, line in ipairs(title_lines) do
		table.insert(lines, line)
		table.insert(title_line_indices, #lines - 1)
	end
	table.insert(lines, "")
	table.insert(lines, "Current time: " .. os.date("%A, %B %d %I:%M %p"))
	time_line_idx = #lines - 1
	table.insert(lines, "Huntersville weather: loading...")
	weather_line_idx = #lines - 1
	table.insert(lines, "")
	local base_count = #lines
	local git_info = get_git_info_lines()
	vim.list_extend(lines, git_info.lines)
	set_buffer_lines(buf, lines)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = false
	vim.api.nvim_set_current_buf(buf)
	start_bufnr = buf
	git_status_lines = {}
	if git_info.highlight and git_info.status_start and git_info.status_count > 0 then
		local first_status_idx = base_count + git_info.status_start
		for i = 0, git_info.status_count - 1 do
			git_status_lines[first_status_idx + i] = git_info.highlight
		end
	end
	apply_highlights(buf)
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

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		set_highlight_groups()
		if start_bufnr and vim.api.nvim_buf_is_valid(start_bufnr) then
			apply_highlights(start_bufnr)
		end
	end,
})
