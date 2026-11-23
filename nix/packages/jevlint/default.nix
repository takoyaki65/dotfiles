{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  pnpm_10_latest ? pnpm_10,
  pnpmConfigHook,
  nodejs_24,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jevlint";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "INDXDev";
    repo = "jevlint";
    rev = "721d9d13ef3e8f45a4fbf7fa605970db7343b1fd";
    hash = "sha256-sLbwzIeskYwTQ5Bz12aysaRg+REtgQmubLeKgWhwnao=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10_latest;
    fetcherVersion = 3;
    hash = "sha256-ZveyQ7QiBUpLtinIkCS7Ysim2T5j4xEiCbvUa/HFXHg=";
  };

  nativeBuildInputs = [ nodejs_24 pnpm_10_latest pnpmConfigHook makeWrapper ];

  env.CI = "true";

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    pnpm prune --prod --ignore-scripts
    mkdir -p $out/lib/jevlint $out/bin
    cp -r dist presets models node_modules package.json $out/lib/jevlint/
    makeWrapper ${nodejs_24}/bin/node $out/bin/jevlint \
      --add-flags "$out/lib/jevlint/dist/cli.mjs"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = builtins.readFile ./install-check.sh;

  meta = {
    description = "Ranks files for refactoring using AST metrics and decision models";
    homepage = "https://github.com/INDXDev/jevlint";
    license = lib.licenses.mit;
    mainProgram = "jevlint";
  };
})
