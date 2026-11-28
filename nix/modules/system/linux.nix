{ pkgs, username, ... }:

let
  dockerConfig = pkgs.writeText "docker-daemon.json" (builtins.toJSON {
    log-driver = "json-file";
    log-opts = {
      max-size = "10m";
      max-file = "3";
    };
  });
in
{
  nix.enable = true;
  nix.settings = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "docker" ];
  };
  users.groups.docker = { };

  # Nixpkgs' Docker CLI already includes Compose and Buildx.
  environment.systemPackages = [ pkgs.docker ];
  environment.etc."docker/daemon.json".source = dockerConfig;

  systemd.services.docker = {
    description = "Docker Application Container Engine";
    after = [
      "docker.socket"
      "firewalld.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
    requires = [ "docker.socket" ];
    wantedBy = [ "system-manager.target" ];
    path = [ pkgs.kmod ];

    unitConfig = {
      StartLimitBurst = 3;
      StartLimitIntervalSec = "60s";
    };
    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.docker}/bin/dockerd --host=fd:// --config-file=${dockerConfig}";
      ExecReload = "${pkgs.coreutils}/bin/kill -s HUP $MAINPID";
      TimeoutStartSec = 0;
      Restart = "always";
      RestartSec = 2;
      LimitNOFILE = 1048576;
      LimitNPROC = "infinity";
      LimitCORE = "infinity";
      TasksMax = "infinity";
      Delegate = true;
      KillMode = "process";
      OOMScoreAdjust = -500;
    };
  };

  systemd.sockets.docker = {
    description = "Docker Socket for the API";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = "/run/docker.sock";
      SocketMode = "0660";
      SocketUser = "root";
      SocketGroup = "docker";
    };
  };
}
