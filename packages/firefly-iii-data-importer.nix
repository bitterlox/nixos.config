{ lib, fetchFromGitHub, php83 }:

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

in phpPackage.buildComposerProject (finalAttrs: {
  inherit pname src version;

  vendorHash = "sha256-dSv8Xcd1YUBr9D/kKuMJSVzX6rel9t7HQv5Nf8NGWCc=";

  #  passthru = {
  #    inherit phpPackage;
  #    tests = nixosTests.firefly-iii;
  #  };

  #  postInstall = ''
  #    mv $out/share/php/${pname}/* $out/
  #    rm -R $out/share $out/storage $out/bootstrap/cache $out/public
  #    ln -s ${dataDir}/storage $out/storage
  #    ln -s ${dataDir}/cache $out/bootstrap/cache
  #  '';

  meta = {
    changelog =
      "https://github.com/firefly-iii/firefly-iii/releases/tag/v${version}";
    description = "Firefly III: a personal finances manager";
    homepage = "https://github.com/firefly-iii/firefly-iii";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.savyajha ];
  };
})
