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
