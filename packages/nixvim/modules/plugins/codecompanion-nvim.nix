args@{
  config,
  helpers,
  lib,
  options,
  ...
}:
{
  plugins.codecompanion.enable = true;

  plugins.codecompanion.settings = {
    strategies = {
      chat = {
        adapter = "anthropic";
        roles = {
          llm = "CodeCompanion"; # The markdown header content for the LLM's responses
          user = "Me"; # The markdown header for your questions
        };
      };
      inline = {
        adapter = "anthropic";
      };
      agent = {
        adapter = "anthropic";
      };
    };
    adapters = {
      openai = helpers.mkRaw ''
         function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            handlers = {
              form_parameters =  function(self, params, messages)
                local custom_params = {
                   provider = {
                     sort = "throughput";
                  }
                };
                return vim.tbl_deep_extend('error', params, custom_params );
              end
            };
            schema = {
              model = {
                default = "deepseek/deepseek-r1-distill-llama-70b"
              };
              num_ctx = {
                default = 8192;
              };
            }
          })
        end
      '';
    };
    opts = {
      log_level = "TRACE";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-a>";
      action = "<cmd>CodeCompanionActions<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<C-a>";
      action = "<cmd>CodeCompanionActions<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<LocalLeader>a";
      action = "<cmd>CodeCompanionChat Toggle<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<LocalLeader>a";
      action = "<cmd>CodeCompanionChat Toggle<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "v";
      key = "ga";
      action = "<cmd>CodeCompanionChat Add<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];

  extraConfigLua = ''
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab cca CodeCompanionActions]])
  '';
}
