args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  ...
}:
let
# TODO: move this into packages top-level
  vectorCodePlugin =
    (pkgs.vimUtils.buildVimPlugin {
      pname = "vectorcode";
      version = "2025-06-02";
      src = pkgs.fetchFromGitHub {
        owner = "Davidyz";
        repo = "VectorCode";
        rev = "2ed7d79c8947afd8592e56ad0f1a5ed2be4dd26f";
        sha256 = "sha256-JG2WF00cDlNOGZbj8ja659fEfwXXbEXFefxk4uhMDtw=";
      };
      meta.homepage = "https://github.com/Davidyz/VectorCode";
      meta.hydraPlatforms = [ ];
    }).overrideAttrs
      (old: {
        dependencies = [ pkgs.vimPlugins.plenary-nvim ];
        # this makes the tests pass as they need access to the cli
        nativeBuildInputs = [ pkgs.vectorcode ];
      });
in
{
  plugins.codecompanion.enable = true;

  extraPlugins = [
    vectorCodePlugin
  ];

  extraPackages = [ pkgs.vectorcode ];

  plugins.codecompanion.settings = {
    extensions.vectorcode = {
      enabled = true;
      opts = {
        add_tool = true; # the @vectorcode tool becomes available in the CodeCompanion chat buffer
        add_slash_command = true; # the /vectorcode slash command
        tool_opts = { };
      };
    };
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
