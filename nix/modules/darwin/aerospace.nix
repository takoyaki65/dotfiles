{ ... }:

{
  services.aerospace = {
    enable = true;
    settings = {
      # Start Aerospace at login
      start-at-login = true;
      gaps = {
        outer.left = 10;
        outer.bottom = 10;
        outer.top = 10;
        outer.right = 10;
      };
    };
  };
}
