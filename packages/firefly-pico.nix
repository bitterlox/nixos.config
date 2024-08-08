{ lib, fetchFromGitHub, buildNpmPackage, php83
, dataDir ? "/var/lib/firefly-pico" }:

# todo: port over streamlining from here
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/fi/firefly-iii/package.nix
let
  pname = "firefly-pico";
  version = "1.2.0";
  phpPackage = php83;

  # how does fetchFromGitHub work?? does it work with a gz file?
  src = fetchFromGitHub {
    owner = "cioraneanu";
    repo = "firefly-pico";
    rev = "${version}";
    hash = "sha256-zJOWuZm5doYXz/PwYy6qMbcCnFwbq8Hc5hhabYXuJQs=";
  };

  # we run this with "node ${out}/server/index.mjs"
  # set up systemd service for this
  # use nodejs light
  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version;
    src = "${src}/front";
    npmDepsHash = "sha256-sxTuQaU7aMBS0hmo1Ai8trFZeYovhCYyv6ilQBndw+o=";
    dontNpmBuild = true;
    # from nixpkgs docs:
    # ... even if you don’t use them directly (the other hooks), it is good
    # practice to do so anyways for downstream users who would want to add a
    # postInstall by overriding your derivation.
    # 
    # disable nuxt telemetry because it asks it thru tty and since it can't
    # get one then crashes build
    installPhase = ''
      runHook preInstall
      NUXT_TELEMETRY_DISABLED=1 npm run build
      cp -r .output $out/
      runHook postInstall
    '';
  };

in phpPackage.buildComposerProject (finalAttrs: {
  inherit pname version;

  src = "${src}/back";

  vendorHash = "sha256-RFOZJdt7Ejnj8RlikrWcl5apELAqu+1UaTTnd4yb4V4=";

  passthru = { inherit phpPackage; };

  postInstall = ''
    mv $out/share/php/${pname}/* $out/
    rm -R $out/share $out/storage $out/bootstrap/cache $out/public
    cp -a ${assets} $out/public
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
    chmod +x $out/artisan
  '';

  meta = {
    changelog =
      "https://github.com/firefly-iii/data-importer/releases/tag/v${version}";
    description = "Lightweight mobile-first frontend for firefly-iii";
  };
})
