{ pkgs, ... }:

let
  nixosVersion = "24.05";
  companyCertPath = ../files/BEDROOTCA001.crt;
in
{
  imports = [
    ./hardware-configuration.nix
    # ./active-directory-integration.nix # TODO: Does not work.
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment = {
    systemPackages = with pkgs; [
      bind # Provides "nslookup" and other useful commands.
      git # Allows access to the upstream NixOS configuration (which is located in a Git repository).
      ncdu # Disk usage analyzer
      vim # A common text-editor.
      wget # A common HTTP tool.
    ];

    variables = {
      # The Nix daemon does not use the standard system certificate when rebuilding, which is why
      # the certificate location has to be specified twice.
      NIX_SSL_CERT_FILE = companyCertPath;
    };
  };

  networking = {
    nameservers = [
      "10.10.32.202"
      "10.10.32.205"
    ];
  };

  nix.settings = {
    # Harden the Nix daemon as described here:
    # https://xeiaso.net/blog/paranoid-nixos-2021-07-18/
    allowed-users = [ "root" ];

    # Enable flakes: https://nixos.wiki/wiki/Flakes
    experimental-features = [ "nix-command" "flakes" ];
  };

  programs.bash = {
    shellAliases = {
      # A better "ll" alias that shows hidden files.
      ll = "ls -la";

      # Get the latest changes from the remote "infrastructure" repository and rebuild the system
      # based on the "/etc/nixos/flake.nix" file.
      nixos = "sudo nix flake lock /etc/nixos --update-input infrastructure && sudo nixos-rebuild switch";
    };
  };

  security = {
    # We need to specify the company's self-signed certificate in order for TLS to work correctly on
    # the system.
    pki.certificates = [
      (builtins.readFile companyCertPath)
    ];

    sudo.extraRules = [{
      users = [ "lhadmin" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];
  };

  services = {
    # Enable SSH for remote administration.
    openssh = {
      enable = true;
      # Disable IPv6 to reduce the attack surface.
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 22;
        }
      ];
    };

    # Enable NTP. We intentionally use the IP address instead of the hostname so that if DNS breaks,
    # NTP will still work correctly.
    timesyncd = {
      enable = true;
      servers = [ "10.10.248.75" ]; # The IP address for: BEDNTP001
    };
  };

  system = {
    # We want to update the system every day to ensure that it automatically gets the latest
    # security updates from the upstream distribution.
    autoUpgrade = {
      enable = true;
      dates = "daily";
      channel = "https://nixos.org/channels/nixos-${nixosVersion}";
    };

    # This value determines the NixOS release from which the default settings for stateful data, like
    # file locations and database versions on your system were taken. It‘s perfectly fine and
    # recommended to leave this value at the release version of the first install of this system.
    # Before changing this value, read the documentation for this option (e.g. man configuration.nix
    # or on https://nixos.org/nixos/options.html).
    stateVersion = nixosVersion;
  };

  users.users.lhadmin = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    # TODO: Get LDAP authentication working. Afterwards, SSH key should correspond to the respective
    # administrator account (e.g. nixosVersion), not "lhadmin".
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCVo+WA+u1Fwpn2o1MRja0RIALcchCSZQpJyN754O1WIlsbnHVKcPxa2Z0ZjzXm7oZ5v0ykJMR+l58tTcUIW5PcSGvGkmEo+zwNc3ToHR0d+0Ja1aaKiRcO1DBLzDYgAZ2TBSd6UiyNKAiwSp7JZTAqAcm80GwdGLCszCV/iBDpw203oYD5fUOXNnhc5FrYIx72FGEiBTPmtcIrFRhvhT5G9qJwKT6galorJ9rAwQ61UCh6sGTjq7ouptqD6+2GfFLqroyNPPoJdny4T9myf+hB2S9qdPXdxSJhwivnoDo2qKk7+do/pWevEPsnooITMnxsOwRMW9Fv9uZM91RR5OImtbe/M4GMmOiU46EQbEvsRxb1sW3ySov/3j6VGA4RvloBBLysn3YM4vVb+bJ62Z2e66IoqX8C0lfBbSSt2+nZRzDNPhicTzIaHw3JfvIEyTTKMGeaeo3zEy1O1vSbI3fAdQhYAb0O6y9vvJOoRO8XUT7hSKrWOm4saXiq152Ivh0= CORP+jnesta@LH6224"

      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsTuO7Xu1BeqSsAlk4aeu+LLy5IwSQQztiaC0z2qaKnh3b5HYHRypCoIputmLdWXAUZXE+EGCmOLFV15FQooibM5ZyBZuLRRRqenu9s/ZHdwFNCNjpQoSroal/ziAD+ET1xiT5AQlBrv52t4TrdNikHGqO/dEzjfMAD8yIjFy2EFlwKcfvsii4rpIjaur55Eca5zfnH99DqB+9eQ833y1z3kExfIkXNtn5Y0GFY/8W7UKU+i1sDKISWCMaEOH9ojygjPG5S2X25Ap7Tj5zJ25Mufz4JAEWxkKBoduRPGFWsOKjsX0MvQ8bHblWGGcBNM2LhJf0JcGky3y2/X2oeCYp56rof+gHMD9JkY2rfwMvkXmbkfrq+nhOdwvEpy8yuxggyz8kt4BlkP5P1fwuWABAOj8Ue1g0CgLt1bLH9EEAwJ/mVMXmuG/gUYchlUrOn23o6mtVsmxAT2hmb6BJykX3mjrT+fTcOuAiV5Z0awbidkS2petcEAGwpeXy6kFn/Qk= CORP+cmuniraju@LHBLRLT189"
    ];
  };

  # We want to install the VMWare guest software so that the hypervisor can better manage this
  # virtual machine.
  virtualisation.vmware.guest.enable = true;
}
