{ ... }:

{
  config = {
    sops = {
      defaultSopsFile = ../../secrets.yaml;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    sops.secrets."prince_license" = {
      path = "/var/lib/prince/license.dat";
      mode = "0444"; # global read permission is fine for our threat model
    };

    sops.secrets."openai_api_key" = {
      mode = "0444";
    };
  };
}
