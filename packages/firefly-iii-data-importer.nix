{ lib
, fetchFromGitHub
, buildNpmPackage
, php83
, nixosTests
, dataDir ? "/var/lib/firefly-iii"
}:

let
  pname = "firefly-iii-data-importer";
  version = "1.5.2";
  phpPackage = php83;

# how does fetchFromGitHub work?? does it work with a gz file?
  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "data-importer";
    rev = "v${version}";
    hash = "0cbc821f9052cf03cebad2870a58527986a1d36077bfa60829c99f00b9919ca3";
  };

in

phpPackage.buildComposerProject (finalAttrs: {
  inherit pname src version;

  vendorHash = "sha256-EpMypgj6lZDz6T94bGoCUH9IVwh7VB4Ds08AcCsreRw=";

  passthru = {
    inherit phpPackage;
    tests = nixosTests.firefly-iii;
  };

  postInstall = ''
    mv $out/share/php/${pname}/* $out/
    rm -R $out/share $out/storage $out/bootstrap/cache $out/public
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  meta = {
    changelog = "https://github.com/firefly-iii/firefly-iii/releases/tag/v${version}";
    description = "Firefly III: a personal finances manager";
    homepage = "https://github.com/firefly-iii/firefly-iii";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.savyajha ];
  };
})
