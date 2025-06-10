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
  # vectorCodePlugin =
  #   (pkgs.vimUtils.buildVimPlugin {
  #     pname = "vectorcode";
  #     version = "2025-06-02";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "Davidyz";
  #       repo = "VectorCode";
  #       rev = "2ed7d79c8947afd8592e56ad0f1a5ed2be4dd26f";
  #       sha256 = "sha256-JG2WF00cDlNOGZbj8ja659fEfwXXbEXFefxk4uhMDtw=";
  #     };
  #     meta.homepage = "https://github.com/Davidyz/VectorCode";
  #     meta.hydraPlatforms = [ ];
  #   }).overrideAttrs
  #     (old: {
  #       dependencies = [ pkgs.vimPlugins.plenary-nvim ];
  #       # this makes the tests pass as they need access to the cli
  #       nativeBuildInputs = [ pkgs.vectorcode ];
  #     });
in
{
  plugins.codecompanion.enable = true;

  extraPlugins = [
    pkgs.vimPlugins.vectorcode-nvim
    # vectorCodePlugin
    pkgs.vimPlugins.codecompanion-history-nvim
  ];

  extraPackages = [ pkgs.vectorcode ];

  plugins.codecompanion.settings = {
    extensions = {
      vectorcode = {
        enabled = true;
        opts = {
          add_tool = true; # the @vectorcode tool becomes available in the CodeCompanion chat buffer
          add_slash_command = true; # the /vectorcode slash command
          tool_opts = { };
        };
      };
      history = {
        enabled = true;
        opts = {
          #  Keymap to open history from chat buffer (default: gh)
          keymap = "gh";
          #  Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = "sc";
          #  Save all chats by default (disable to save only manually using 'sc')
          auto_save = true;
          #  Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 0;
          #  Picker interface (auto resolved to a valid picker)
          picker = "telescope"; # ("telescope", "snacks", "fzf-lua", or "default")
          # Automatically generate titles for new chats
          auto_generate_title = true;
          title_generation_opts = {
            # Adapter for generating titles (defaults to current chat adapter)
            # adapter = nil; #  "copilot"
            # Model for generating titles (defaults to current chat model)
            # model = nil; #  "gpt-4o"
            # Number of user prompts after which to refresh the title (0 to disable)
            refresh_every_n_prompts = 0; # e.g., 3 to refresh after every 3rd user prompt
            # Maximum number of times to refresh the title (default: 3)
            max_refreshes = 3;
          };
          # On exiting and entering neovim; loads the last chat on opening chat
          continue_last_chat = false;
          # When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false;
          # Directory path to save the chats
          dir_to_save = helpers.mkRaw ''
            vim.fn.stdpath("data") .. "/codecompanion-history"
          '';
          # Enable detailed logging for history extension
          enable_logging = false;
        };
      };
    };
    strategies = {
      chat = {
        adapter = "openai";
        roles = {
          llm = "CodeCompanion"; # The markdown header content for the LLM's responses
          user = "Me"; # The markdown header for your questions
        };
      };
      inline = {
        adapter = "openai";
      };
      agent = {
        adapter = "openai";
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
                default = "google/gemini-2.5-pro-preview"
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
