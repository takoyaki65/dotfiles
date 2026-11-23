import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class ShellSessionTest(unittest.TestCase):
    def test_session_initialization(self):
        for shell in ("bash", "zsh"):
            for custom_xdg in (False, True):
                for has_profile in (False, True):
                    with self.subTest(shell=shell, custom_xdg=custom_xdg,
                                      has_profile=has_profile):
                        self.check_session(shell, custom_xdg, has_profile)

    def check_session(self, shell, custom_xdg, has_profile):
        executable = shutil.which(shell)
        self.assertIsNotNone(executable, f"{shell} is required")
        with tempfile.TemporaryDirectory(prefix="dotfiles shell ") as directory:
            home = Path(directory)
            config = home / ("custom config" if custom_xdg else ".config")
            (config / "shell").mkdir(parents=True)
            (config / "shell/hm-session.sh").symlink_to(
                ROOT / "config/shell/hm-session.sh"
            )
            profile = home / ".local/state/home-manager/gcroots/current-home/home-path"
            if has_profile:
                (profile / "etc/profile.d").mkdir(parents=True)
                (profile / "etc/profile.d/hm-session-vars.sh").write_text(
                    "export SESSION_VALUE='value with spaces=equals'\n"
                )
                (profile / "bin").mkdir()
                worktrunk = profile / "bin/wt"
                worktrunk.write_text(
                    '#!/bin/sh\nprintf "export WT_SHELL=%s\\n" "$4"\n'
                )
                worktrunk.chmod(0o755)

            environment = {
                "HOME": str(home),
                "USER": "dotfiles-session-test",
                "PATH": "/usr/bin:/bin",
                "LC_ALL": "C",
            }
            if custom_xdg:
                environment["XDG_CONFIG_HOME"] = str(config)
            flags = ["--noprofile", "--norc"] if shell == "bash" else ["-f"]
            result = subprocess.run(
                [executable, *flags, "-c",
                 '. "$1"; . "$1"; printf "%s\\n" '
                 '"${SESSION_VALUE-}" "$PATH" "${WT_SHELL-}" '
                 '"${HM_SESSION_VARS-unset}" "${HM_PATH_BIN-unset}"',
                 shell, str(ROOT / f"config/{shell}/{shell}rc")],
                env=environment, text=True, capture_output=True, check=True,
            )
            self.assertEqual(result.stderr, "")
            value, path, integration, session_var, path_var = result.stdout.splitlines()
            expected_bin = (str(profile / "bin") if has_profile else
                            "/etc/profiles/per-user/dotfiles-session-test/bin")
            self.assertEqual(path.split(os.pathsep),
                             [expected_bin, "/usr/bin", "/bin"])
            self.assertEqual(value, "value with spaces=equals" if has_profile else "")
            self.assertEqual(integration, shell if has_profile else "")
            self.assertEqual((session_var, path_var), ("unset", "unset"))


if __name__ == "__main__":
    unittest.main()
