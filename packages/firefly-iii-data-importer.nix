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
    #rev = "develop-20240702";
    # v1.5.2
    hash = "sha256-xGYaSoK6luGTZ2/waGbnnvdXk1IoyseSbD/uW8KIqto=";
    # develop/2024-07-02 
    #hash = "sha256-soJ2Z3DO6Y1H787CEAgsZc1U18Oi1DdqYFrzB5n/e84=";

  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    # v1.5.2
    npmDepsHash = "sha256-ZSHMDalFM3Iu7gL0SoZ0akrS5UAH1FOWTRsGjzM7DWA=";
    # develop/2024-07-02 
    #npmDepsHash = "sha256-je37E3vE12HvZ1HIPfMYx6ReD4dwWVN9PqDg23BTMu8=";
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

  # v1.5.2
  vendorHash = "sha256-dSv8Xcd1YUBr9D/kKuMJSVzX6rel9t7HQv5Nf8NGWCc=";
  # develop/2024-07-02 
  #vendorHash = "sha256-4Sxl5GJh2iubMutNd7pIQZVJ4NWEEkeZDDZEMxG7U80=";

  passthru = { inherit phpPackage; };

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
