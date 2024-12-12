# this is a nixvim module
args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  specialArgs,
}:
{

  plugins.lsp.servers.tailwindcss.enable = true;
  # https://github.com/tailwindlabs/tailwindcss-intellisense?tab=readme-ov-file#extension-settings
  plugins.lsp.servers.tailwindcss.settings = {
    tailwindCSS = {
      classAttributes = [
        "class"
        "className"
        "class:list"
        "classList"
        "ngClass"
      ];
      includeLanguages = {
        eelixir = "html-eex";
        eruby = "erb";
        htmlangular = "html";
        templ = "html";
      };
      lint = {
        cssConflict = "warning";
        invalidApply = "error";
        invalidConfigPath = "error";
        invalidScreen = "error";
        invalidTailwindDirective = "error";
        invalidVariant = "error";
        recommendedVariantOrder = "warning";
      };
      validate = true;
    };
  };

  plugins.lsp.servers.efm.enable = true;
  # enable on all files
  plugins.lsp.servers.efm.filetypes = [ "yaml" ];
  plugins.lsp.servers.efm.extraOptions = {
    init_options = {
      documentFormatting = true;
      documentRangeFormatting = true;
      hover = true;
      documentSymbol = true;
      codeAction = true;
      completion = true;
    };
  };

  plugins.efmls-configs.enable = true;
  # biome should support css i think
  plugins.efmls-configs.setup.css.formatter = [ "stylelint" ];
  plugins.efmls-configs.setup.css.linter = [ "stylelint" ];
}
