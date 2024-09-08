local cokeline = require("cokeline")
local get_hex = require("cokeline.hlgroups").get_hl_attr

cokeline.setup({
  default_hl = {
    fg = function(buffer)
      return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg")
    end,
    bg = get_hex("ColorColumn", "bg"),
  },

  components = {
    {
      text = "｜",
      fg = function(buffer)
        return buffer.is_modified and yellow or green
      end,
    },
    {
      text = function(buffer)
        return buffer.devicon.icon .. " "
      end,
      fg = function(buffer)
        return buffer.devicon.color
      end,
    },
    {
      text = function(buffer)
        return buffer.index .. ": "
      end,
    },
    {
      text = function(buffer)
        return buffer.unique_prefix
      end,
      fg = get_hex("Comment", "fg"),
      style = "italic",
    },
    {
      text = function(buffer)
        return buffer.filename .. " "
      end,
      style = function(buffer)
        return buffer.is_focused and "bold" or nil
      end,
    },
    {
      text = " ",
    },
  },
})
