# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  meta,
  modulesPath,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    "${toString modulesPath}/profiles/qemu-guest.nix"
    "${toString modulesPath}/profiles/headless.nix"
  ];

  networking.hostName = meta.hostname; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Force getting the hostname from Openstack metadata.
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  # Fixes for longhorn
  systemd.tmpfiles.rules = [ "L+ /usr/local/bin - - - - /run/current-system/sw/bin/" ];
  virtualisation.docker.logDriver = "json-file";

  # Enable the serial console on tty1
  systemd.services."serial-getty@tty1".enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    #  pwgen -s -n 16 | head -n1 on the first time then comment the token line and uncomment the tokeFile
    # token = "XXXXXXXXXXXXXXXX";
    #tokenFile = /var/lib/rancher/k3s/server/token;
    extraFlags = toString (
      [
        "--write-kubeconfig-mode \"0644\""
        "--cluster-init"
        "--disable servicelb"
        "--disable traefik"
        "--disable local-storage"
      ]
      ++ (if meta.hostname == "nix-k3s-0" then [ ] else [ "--server https://nix-k3s-0:6443" ])
    );
    clusterInit = (meta.hostname == "nix-k3s-0");
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${meta.hostname}";
  };

  # Allow root logins
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    package = pkgs.nixFlakes;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    k3s
    cifs-utils
    nfs-utils
    git
  ];

  security.sudo.wheelNeedsPassword = false;

  # Nothing can possibly hash to just "!". This way, it disable password.
  users.users.root.hashedPassword = "!";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vinetos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    # Created using mkpasswd
    hashedPassword = "$6$uF0LmDHGNGUfrOA6$gDe3mx43e4lj273yJxYsAOiOkPWg5gZtLAQxgMxoX/pLyuHdEaAAsck6woayxFRR0jlkQAoY8UpvHdcCLyekY/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJmry9psCtllFsR41Cvo3fL0V+6RhS4reklJ24CwXC0"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGAdZ04XrnQV/tATz7mKMDwTk0CVVBFmXjxXeh9Eo73"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtVM4VVm/4N6rYHcAxfHoiQPs5v/Luj7fTjct2541/YuUUTtA0OQ4BbOsrOVQgjxqXyr8IMYjIODAfS4DzurEvT4R95IEvvXbsvkxzbA3IgLPoF76xoehI2U42DwVOsmnG4l8RZPQu4NdfMOK2XIaQYau9UCj5QGZcu8bBTXjwsa50JHHktc6mfASFtTdZc5AAx5g/PDpQf9QA/jrpSpWtYej/e4uhTBC3YK93AtLjvKVvqmW7hXNM32847RbuAs1qmF7QgGa5HFn8bVTAVFIFUG+J2VeftgOMHjqKmwxZdN+gIVrV3rkusK7qBUESxwZ30bq/xnpaFrnnQjX4TvtxCcqdscN31lipTzerg8B1GAiZWWEBG0tp5/1+0GbYgGwdPQDt5xaYAYv+bXyAwSCt29QptCCFSW/pSjZ43sC9UEbuphJGXcL3BYUTjxSut+yyf0Dt+Kclrwsyyf30FLcR35hoSElKnHgjQiSU8W6lUgNo6aFgXOoevtxMrKuHErq6jroDXJGkVn602ufKeW2UwthA5yBnHKt5GWiIqGkGA6wENS1520EqvOAgmcKBZMgeJI+6VjXH6e4wGBAXPL/5VgToB3gpxuO5pkjF9Lu0u6t/OiDiksFJa2IghpyII22YaqWks9L0+dgz7pwUYntHvLotn2Y2X7ma/iJLPEzm2w=="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQEAHu9Td7bRxtdzocnnKjBavBEl8WYJT1fs6Rq5yN7Q3s+ZKoNs+CeN8S9qwEpz1dE2Jh1pt6VKPMypewFrgjw22sdauDoNneCaPltvtw3VjIY/TnEnsq1QLj6GD23UejbuWqaBjug2Ov4yj2rVFUwgA6iqPj66sZOe5LWp3F8ALmvqd0eS1769f75CpPX1yZl5cXg4y/uiX4qhnv0QiPCo3BM03oPAhUZ0zV9nc506dFjOjNLTpQnJJWKrqQ5/yK53uPMMpiV1WrYEb2QuTbQpkhaXoQUju1Q2HNlt1fitJrsp+JMz9uyI6MwaOH3gJtyT2tvDzGYruCn+e5sBKOCfnatUtVdvIm5kHulCAwOfPs8sQB3KLljECew/zfjsMhW9+8FknZ2zzRrtcsw0h+fYwdYwq0eFjuzxqp1mzYUyPlQKY9Y9Bjlea+vNXMl9LITg0kExuhPoFDK7tag0wpPFhglirg1MjgfLf439pgI01DiDjGmrTCH3x6qGtJ/rY5ic37puXt8EiPbcif4Bhkxsi9ZUruDzsyuILamwGGSQnwipCQwqKZjDaPmviU5KCQcsVmwEnuUVk/TeCrMEGpAq1pRxzcirtf/ikkgOhBrI8+2ttD1/tfvzbOK0Z8SgklT6V7G2MtWiqfWxhGxFqeKbMPnjLvndcX/xwxkukHCw=="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcUkY7yHnguiE/6H8gZ54bvhvtwD3OurXa6rg6iNW6o"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7FrJj+PLV0Cw15pAVesiBj2g9Ad1rU3sFgtC2ebULH"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Fetch
  systemd.services.openstack-init = {
    path = [ pkgs.wget ];
    description = "Fetch Openstack Metadata on startup";
    wantedBy = [ "multi-user.target" ];
    before = [ "apply-openstack-data.service" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    script = ''

      metaDir=/etc/openstack-metadata
      mkdir -m 0755 -p "$metaDir"
      rm -f "$metaDir/*"

      echo "getting instance metadata..."

      wget_imds() {
        wget --retry-connrefused "$@"
      }

      wget_imds -O "$metaDir/ami-manifest-path" http://169.254.169.254/1.0/meta-data/ami-manifest-path || true
      # When no user-data is provided, the OpenStack metadata server doesn't expose the user-data route.
      (umask 077 && wget_imds -O "$metaDir/user-data" http://169.254.169.254/1.0/user-data || rm -f "$metaDir/user-data")
      wget_imds -O "$metaDir/hostname" http://169.254.169.254/1.0/meta-data/hostname || true
      wget_imds -O "$metaDir/public-keys-0-openssh-key" http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key || true
    '';
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.apply-openstack-data = {
    description = "Apply Openstack Data";
    wantedBy = [
      "multi-user.target"
      "sshd.service"
    ];
    before = [ "sshd.service" ];
    after = [ "fetch-openstack-metadata.service" ];
    path = [ pkgs.iproute2 ];
    script = ''

      echo "setting host name..."
      if [ -s /etc/openstack-metadata/hostname ]; then
          ${pkgs.nettools}/bin/hostname $(cat /etc/openstack-metadata/hostname)
      fi

      if ! [ -e /home/nixos/.ssh/authorized_keys ]; then
          echo "obtaining SSH key..."
          mkdir -m 0700 -p /home/nixos/.ssh
          if [ -s /etc/openstack-metadata/public-keys-0-openssh-key ]; then
              cat /etc/openstack-metadata/public-keys-0-openssh-key >> /home/nixos/.ssh/authorized_keys
              echo "new key added to authorized_keys"
              chmod 600 /home/nixos/.ssh/authorized_keys
          fi
          chown -R nixos:users /home/nixos/.ssh
      fi

      # Extract the intended SSH host key for this machine from
      # the supplied user data, if available.  Otherwise sshd will
      # generate one normally.
      userData=/etc/openstack-metadata/user-data

      mkdir -m 0755 -p /etc/ssh

      if [ -s "$userData" ]; then
        key="$(sed 's/|/\n/g; s/SSH_HOST_DSA_KEY://; t; d' $userData)"
        key_pub="$(sed 's/SSH_HOST_DSA_KEY_PUB://; t; d' $userData)"
        if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_dsa_key ]; then
            (umask 077; echo "$key" > /etc/ssh/ssh_host_dsa_key)
            echo "$key_pub" > /etc/ssh/ssh_host_dsa_key.pub
        fi

        key="$(sed 's/|/\n/g; s/SSH_HOST_ED25519_KEY://; t; d' $userData)"
        key_pub="$(sed 's/SSH_HOST_ED25519_KEY_PUB://; t; d' $userData)"
        if [ -n "$key" -a -n "$key_pub" -a ! -e /etc/ssh/ssh_host_ed25519_key ]; then
            (umask 077; echo "$key" > /etc/ssh/ssh_host_ed25519_key)
            echo "$key_pub" > /etc/ssh/ssh_host_ed25519_key.pub
        fi
      fi
    '';

    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
  };

  systemd.services.print-host-key = {
    description = "Print SSH Host Key";
    wantedBy = [ "multi-user.target" ];
    after = [ "sshd.service" ];
    script = ''

      # Print the host public key on the console so that the user
      # can obtain it securely by parsing the output
      echo "-----BEGIN SSH HOST KEY FINGERPRINTS-----" > /dev/console
      for i in /etc/ssh/ssh_host_*_key.pub; do
          ${pkgs.openssh}/bin/ssh-keygen -l -f $i > /dev/console
      done
      echo "-----END SSH HOST KEY FINGERPRINTS-----" > /dev/console
    '';
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
