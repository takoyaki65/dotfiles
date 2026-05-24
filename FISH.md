{{DISPLAYTITLE:fish}}
fish, the [http://fishshell.com/ Friendly Interactive Shell], is a [[Command Shell|command shell]] designed around user-friendliness.

== Installation ==

A basic user-specific installation with [[Home Manager]] may look like this:

<syntaxhighlight lang="nix">
home-manager.users.myuser = {
  programs.fish.enable = true;
};
</syntaxhighlight>

Change <code>myuser</code> to the username of the user you want to configure.

You can enable the fish shell and manage fish configuration and plugins with Home Manager, but to enable vendor fish completions provided by Nixpkgs you will also want to enable the fish shell in <code>/etc/nixos/configuration.nix</code>:

<syntaxhighlight lang="nix">
  programs.fish.enable = true;
</syntaxhighlight>

== Setting fish as your shell ==

Warning! [https://fishshell.com/docs/current/index.html#default-shell As noted in the fish documentation], using fish as your *login* shell (referenced in <code>/etc/passwd</code>) may cause issues because fish is not POSIX compliant. In particular, this author found systemd's emergency mode to be completely broken when fish was set as the login shell.

This issue is discussed extensively on the [https://wiki.gentoo.org/wiki/Fish#Caveats Gentoo] and [https://wiki.archlinux.org/title/Fish#System_integration Arch] wikis. There they present an alternative, keeping bash as the system shell but having it exec fish when run interactively.

Here is one solution, which launches fish unless the parent process is already fish:

<syntaxhighlight lang="nix">
programs.bash = {
  interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';
};
</syntaxhighlight>

If you still want to set fish as the login shell, see [[Command Shell#Changing default shell]].

== Configuration ==

=== System wide ===

To enable fish plugins, add your preferred plugins to `environment.systemPackages`:

<syntaxhighlight lang="nix">
environment.systemPackages = with pkgs; [
  fishPlugins.done
  fishPlugins.fzf-fish
  fishPlugins.forgit
  fishPlugins.hydro
  fzf
  fishPlugins.grc
  grc
];

programs.fish.enable = true;
</syntaxhighlight>

=== Home Manager ===

An example configuration in Home Manager for adding plugins and changing options could look like this:

<syntaxhighlight lang="nix">
home-manager.users.myuser = {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      # Manually packaging and enable a plugin
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
    ];
  };
};
</syntaxhighlight>
Full list of home-manager options for fish can be found  See also [https://github.com/nix-community/home-manager/blob/master/modules/programs/fish.nix here].

See [https://search.nixos.org/packages?channel=unstable&from=0&size=50&buckets=%7B%22package_attr_set%22%3A%5B%22fishPlugins%22%5D%2C%22package_license_set%22%3A%5B%5D%2C%22package_maintainers_set%22%3A%5B%5D%2C%22package_platforms%22%3A%5B%5D%7D&sort=relevance&query=fishPlugins fishPlugins package set] for available plugins in nixpkgs.

== Useful scripts ==

=== Show that you are in a nix-shell ===
Add this to the <code>fish_prompt</code> function (usually placed in <code>~/.config/fish/functions/fish_prompt.fish</code>):

<syntaxhighlight lang="fish">
set -l nix_shell_info (
  if test -n "$IN_NIX_SHELL"
    echo -n "<nix-shell> "
  end
)
</syntaxhighlight>

and <code>$nix_shell_info</code> to the echo in that function, e.g.:

<syntaxhighlight lang="fish">
echo -n -s "$nix_shell_info ~>"
</syntaxhighlight>

Now your prompt looks like this:

* outside: <code>~></code>
* inside: <code><nix-shell> ~></code>

You can directly start nix-shell in fish with <code>nix-shell --run fish</code>.

=== Environments ===
Here are some examples of helper functions that put you in a nix-shell with the given packages installed. 

You can either put these in <code>programs.fish.functions</code> with home-manager or in <code>~/.config/fish/functions/fish_prompt.fish</code> without.

==== haskellEnv ====

<syntaxhighlight lang="fish">
function haskellEnv
  nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])"
end
</syntaxhighlight>
 
 # Invocation: haskellEnv package1 packages2 .. packageN

==== pythonEnv ====

<syntaxhighlight lang="fish">
function pythonEnv --description 'start a nix-shell with the given python packages' --argument pythonVersion
  if set -q argv[2]
    set argv $argv[2..-1]
  end
 
  for el in $argv
    set ppkgs $ppkgs "python"$pythonVersion"Packages.$el"
  end
 
  nix-shell -p $ppkgs
end

# Invocation: pythonEnv 3 package1 package2 .. packageN
# or:         pythonEnv 2 ..
</syntaxhighlight>

== See also ==

* [[Command Shell]]

[[Category:Applications]]

