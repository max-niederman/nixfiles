{ ... }:

{
  imports = [
    ./nix.nix
    ./desktop.nix
    ./user.nix
    ./development.nix
    ./network.nix
    ./boot.nix
  ];

  config = {
    sops = {
      defaultSopsFile = ../../secrets.yaml;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
