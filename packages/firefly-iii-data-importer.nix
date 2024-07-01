{ lib, fetchFromGitHub, buildNpmPackage, php83
, dataDir ? "/var/lib/firefly-iii-data-importer" }:

let
  pname = "firefly-iii-data-importer";
  version = "1.5.2";
  phpPackage = php83;

  # how does fetchFromGitHub work?? does it work with a gz file?
  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    rev = "v${version}";
    hash = "sha256-xGYaSoK6luGTZ2/waGbnnvdXk1IoyseSbD/uW8KIqto=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-ZSHMDalFM3Iu7gL0SoZ0akrS5UAH1FOWTRsGjzM7DWA=";
    dontNpmBuild = true;
    # from nixpkgs docs:
    # ... even if you don’t use them directly, it is good practice to do so anyways for
    # downstream users who would want to add a postInstall by overriding your derivation.
    installPhase = ''
      runHook preInstall
      npm run build --workspace=v2
      cp -r ./public $out/
      runHook postInstall
    '';
  };

in phpPackage.buildComposerProject (finalAttrs: {
  inherit pname src version;

  vendorHash = "sha256-dSv8Xcd1YUBr9D/kKuMJSVzX6rel9t7HQv5Nf8NGWCc=";

  #  passthru = {
  #    inherit phpPackage;
  #    tests = nixosTests.firefly-iii;
  #  };

  postInstall = ''
    mv $out/share/php/${pname}/* $out/
    rm -R $out/share $out/storage $out/bootstrap/cache $out/public
    cp -a ${assets} $out/public
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  meta = {
    changelog =
      "https://github.com/firefly-iii/data-importer/releases/tag/v${version}";
    description = "Data importer for Firefly III";
  };
})
