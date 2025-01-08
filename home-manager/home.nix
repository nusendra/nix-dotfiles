{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./nvim
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "nusendra";
    homeDirectory = "/Users/nusendra";
    sessionVariables = {
      # Set environment variables here
      ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
      ANDROID_NDK_HOME="${config.home.homeDirectory}/Library/Android/sdk/ndk";
      JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
      PATH = pkgs.lib.mkBefore "${config.home.homeDirectory}/Library/Android/sdk/emulator:${config.home.homeDirectory}/Library/Android/sdk/platform-tools";
      NVM_DIR = "$HOME/.nvm";
    };
  };

  home.packages = with pkgs; [
    ripgrep
  ];


  # Enable home-manager and  git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.tmux.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false; # enabled in oh-my-zsh
    shellAliases = {
      v ="nvim";
      t ="tmux";
      work ="cd ~/Projects/";
      nixconf = "cd ~/.config/nix";
      gplom = "git pull origin master";
      gploma = "git pull origin main";
      gplod = "git pull origin dev";
      gpsom = "git push origin master";
      gpsoma = "git push origin main";
      gpsod = "git push origin dev";
      gcm = "git checkout master";
      gcd = "git checkout dev";
      gs = "git status";
      gd = "git diff";
      gst = "git stash";
      gcb = "git checkout -b ";
      gc = "git checkout ";
      glo = "git log --oneline";
      gl = "git log";
      gpo = "git push origin ";
      ga = "git add .";
      gcom = "git commit -m ";
      gmer = "git merge ";

      devphp = "cd ~/.config/nix/ && nix develop '.#devShells.php'";
      devphp81 = "cd ~/.config/nix/ && nix develop '.#devShells.php81'";
      devjs = "cd ~/.config/nix/ && nix develop '.#devShells.js'";
      devrust = "cd ~/.config/nix/ && nix develop '.#devShells.rust'";
      devmariadb = "cd ~/.config/nix/ && nix develop '.#devShells.mariadb'";
      develasticsearch = "cd ~/.config/nix/ && export NIXPKGS_ALLOW_UNFREE=1 && nix develop --impure '.#devShells.elasticsearch'";

      dcb = "docker-compose build";
      dcu = "docker-compose up";
      dcud = "docker-compose up -d";
      dcd = "docker-compose down";

      dcbdev = "docker-compose -f docker-compose.dev.yml build";
      dcudev = "docker-compose -f docker-compose.dev.yml up";
      dcuddev = "docker-compose -f docker-compose.dev.yml up -d";
      dcddev = "docker-compose -f docker-compose.dev.yml down";

      dcbprod = "docker-compose -f docker-compose.prod.yml build";
      dcuprod = "docker-compose -f docker-compose.prod.yml up";
      dcudprod = "docker-compose -f docker-compose.prod.yml up -d";
      dcdprod = "docker-compose -f docker-compose.prod.yml down";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

      export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
      export DOCKER_HOST=unix:///Users/nusendra/.docker/run/docker.sock
    '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
