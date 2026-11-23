from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


FISH = shutil.which("fish")
FISH_CONFIG = Path(__file__).resolve().parents[1] / "config/fish"


class FishStartupTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="fish startup ")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.profile = self.home / ".local/state/home-manager/gcroots/current-home/home-path"
        self.bin = self.profile / "bin"
        self.bin.mkdir(parents=True)
        self.session = self.profile / "etc/profile.d/hm-session-vars.sh"
        self.session.parent.mkdir(parents=True)
        self.session.write_text("export FISH_TEST_VALUE='spaces and=equals'\n")
        self.env = {
            "HOME": str(self.home),
            "USER": "dotfiles-fish-test",
            "XDG_CONFIG_HOME": str(self.home / "config"),
            "XDG_DATA_HOME": str(self.home / "data"),
            "XDG_CACHE_HOME": str(self.home / "cache"),
            "PATH": "/usr/bin:/bin",
            "TERM": "xterm",
            "FISH_TEST_LOG": str(self.home / "tools.log"),
            "__HM_SESS_VARS_SOURCED": "1",
        }
        self.tool("uname", "printf 'Linux\\n'")
        self.tool("vivid", "printf 'test-colors\\n'")
        self.tool("direnv", 'printf "set -gx FISH_TEST_DIRENV %s\\n" "$1"')
        self.tool("starship", "printf 'set -gx FISH_TEST_STARSHIP ready\\n'")
        self.tool("zoxide", "printf 'set -gx FISH_TEST_ZOXIDE ready\\n'")

    def tool(self, name, body):
        path = self.bin / name
        path.write_text(
            '#!/bin/sh\nprintf "%s %s\\n" "${0##*/}" "$*" >> "$FISH_TEST_LOG"\n'
            + body + "\n"
        )
        path.chmod(0o755)

    def run_fish(self, assertions, interactive=False):
        command = [FISH, "--no-config"]
        if interactive:
            command.append("--interactive")
        result = subprocess.run(
            command + ["-c", """
                set -gx USER dotfiles-fish-test
                set -g fish_function_path $argv[1]/functions $fish_function_path
                source $argv[1]/config.fish
                eval $argv[2]
            """, str(FISH_CONFIG), assertions.replace("\n", " ")],
            env=self.env, capture_output=True, text=True, timeout=10,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout, "")
        return result

    def test_syntax(self):
        subprocess.run([FISH, "--no-execute", *map(str, FISH_CONFIG.rglob("*.fish"))], check=True, timeout=10)

    def test_interactive_startup_loads_environment_before_tools(self):
        self.tool("vivid", 'test "$FISH_TEST_VALUE" = "spaces and=equals" || exit 1\nprintf "test-colors\\n"')
        self.run_fish("""
            test "$FISH_TEST_VALUE" = 'spaces and=equals'; and
            test "$PATH[1]" = "$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin"; and
            test "$LS_COLORS" = test-colors; and
            test "$FISH_TEST_DIRENV" = hook; and
            test "$FISH_TEST_STARSHIP" = ready; and
            test "$FISH_TEST_ZOXIDE" = ready; and
            functions -q del delete
        """, interactive=True)

    def test_noninteractive_startup_only_exports_direnv(self):
        self.run_fish("""
            test "$FISH_TEST_VALUE" = 'spaces and=equals'; and
            test "$FISH_TEST_DIRENV" = export; and
            not set -q FISH_TEST_STARSHIP; and
            not set -q FISH_TEST_ZOXIDE
        """)
        self.assertEqual((self.home / "tools.log").read_text(), "direnv export fish\n")

    def test_missing_tools_are_silent(self):
        for tool in ("vivid", "direnv", "starship", "zoxide"):
            (self.bin / tool).unlink()
        result = self.run_fish("functions -q del delete", interactive=True)
        self.assertNotIn("not found", result.stderr)

    def test_failed_tool_is_retried_on_next_startup(self):
        self.tool("starship", "echo 'starship init failed' >&2\nexit 23")
        result = self.run_fish("test $FISH_TEST_ZOXIDE = ready", interactive=True)
        self.assertIn("starship init failed", result.stderr)
        self.tool("starship", "printf 'set -gx FISH_TEST_STARSHIP recovered\\n'")
        self.run_fish("test $FISH_TEST_STARSHIP = recovered", interactive=True)

    def test_failed_session_does_not_import_partial_environment(self):
        self.session.write_text("export FISH_TEST_VALUE=partial\nfalse\n")
        result = self.run_fish("not set -q FISH_TEST_VALUE")
        self.assertIn("Failed to load Home Manager session variables", result.stderr)

    def test_missing_session_and_profile_are_optional(self):
        self.session.unlink()
        shutil.rmtree(self.bin)
        self.run_fish("not set -q FISH_TEST_VALUE")


if __name__ == "__main__":
    unittest.main()
