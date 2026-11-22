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
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME="$TMPDIR/jevlint-home"
    export XDG_CONFIG_HOME="$HOME/config"
    export XDG_CACHE_HOME="$HOME/cache"
    mkdir -p "$HOME/project"
    cd "$HOME/project"
    printf '%s\n' 'function f(a,b,c,d,e) { return a; }' > sample.ts
    printf '%s\n' 'def f(a,b,c,d,e):' '    return a' > sample.py
    printf '%s\n' 'package sample' 'func f(a,b,c,d,e int) int { return a }' > sample.go
    printf '%s\n' 'fn f(a:i32,b:i32,c:i32,d:i32,e:i32) -> i32 { a }' > sample.rs
    $out/bin/jevlint audit --ast-only --json > report.json
    node --input-type=module -e '
      import assert from "node:assert/strict";
      import { readFileSync } from "node:fs";
      const report = JSON.parse(readFileSync("report.json", "utf8"));
      assert.equal(report.files.length, 4);
      for (const file of report.files) {
        assert.ok(file.ast && !file.ast.approximate, file.path);
        assert.ok(file.ast.findings.some(f => f.rule === "params"), file.path);
      }
    '
    mkdir -p "$XDG_CONFIG_HOME/jevlint"
    printf '%s\n' 'presets = ["readable-code", "clean-code"]' '[provider]' 'name = "local"' \
      > "$XDG_CONFIG_HOME/jevlint/config.toml"
    $out/bin/jevlint audit --json > local-report.json
    node --input-type=module -e '
      import assert from "node:assert/strict";
      import { readFileSync } from "node:fs";
      const report = JSON.parse(readFileSync("local-report.json", "utf8"));
      assert.equal(report.provider, "local");
      assert.equal(report.files.length, 4);
      for (const file of report.files) {
        assert.ok(file.model?.answers.length > 0, file.path);
      }
    '
    runHook postInstallCheck
  '';

  meta = {
    description = "Ranks files for refactoring using AST metrics and decision models";
    homepage = "https://github.com/INDXDev/jevlint";
    license = lib.licenses.mit;
    mainProgram = "jevlint";
  };
})
