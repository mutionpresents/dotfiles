return {version=12,pkgs={{source="lazy",file="lazy.lua",spec=function()
return {
  -- nui.nvim can be lazy loaded
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "folke/noice.nvim",
  },
}

end,name="noice.nvim",dir="/home/mution/.local/share/nvim/lazy/noice.nvim",},{source="lazy",file="community",spec={"nvim-lua/plenary.nvim",lazy=true,},name="plenary.nvim",dir="/home/mution/.local/share/nvim/lazy/plenary.nvim",},},}