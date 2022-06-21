{ config, pkgs, lib, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    screenSection = ''
      Option "TearFree" "true"
    '';
  };

  hardware.opengl = {
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];

    driSupport = true;
    driSupport32Bit = true;
  };

  home-manager.sharedModules = [{
    programs.autorandr = {
      enable = true;
      profiles = {
        default = {
          fingerprint = {
            "DisplayPort-1" = "00ffffffffffff0005e30127770a0200191e0104a53c22783bdad5ad5048a625125054bfef00d1c081803168317c4568457c6168617c565e00a0a0a029503020350055502100001e40e7006aa0a067500820980455502100001a000000fc0051323747315747340a20202020000000fd003090e6e63c010a20202020202001b502031ff14c0103051404131f120211903f230907078301000065030c0010006fc200a0a0a055503020350055502100001e5aa000a0a0a046503020350055502100001e023a801871382d40582c450055502100001eab22a0a050841a303020360055502100001af03c00d051a0355060883a0055502100001c00000000000080";
            "DisplayPort-2" = "00ffffffffffff0005e301272d190100301d0104a53c22783bdad5ad5048a625125054bfef00d1c081803168317c4568457c6168617c565e00a0a0a029503020350055502100001e40e7006aa0a067500820980455502100001a000000fc0051323747315747340a20202020000000fd003090e6e63c010a20202020202001db02031ff14c0103051404131f120211903f230907078301000065030c0010006fc200a0a0a055503020350055502100001e5aa000a0a0a046503020350055502100001e023a801871382d40582c450055502100001eab22a0a050841a303020360055502100001af03c00d051a0355060883a0055502100001c00000000000080";
            "HDMI-A-0" = "00ffffffffffff0010aca1d0554e4433031c0103803c2278eacd25a3574b9f270d5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c450056502100001e000000ff0039334a574b38314a33444e550a000000fc00534532373137482f48580a2020000000fd00384c1e5311000a20202020202001a1020320b14c9005040302071601141f121365030c001000681a00000101304be62a4480a0703827403020350056502100001a011d8018711c1620582c250056502100009e011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e9600565021000018000000000000000000000000000000000000000000000028";
          };
          config = {
            "DisplayPort-1" = {
              position = "0x0";
              mode = "2560x1440";
              rate = "120.00";
            };
            "DisplayPort-2" = {
              position = "2560x0";
              mode = "2560x1440";
              rate = "120.00";
              primary = true;
            };
            "HDMI-A-0" = {
              position = "5120x0";
              mode = "1920x1080";
              rate = "75.00";
            };
          };
        };
      };
    };

    xsession.initExtra = ''
      ${pkgs.autorandr}/bin/autorandr -c
    '';

    max.desktop = {
      wm.bspwm.monitors = {
        "DisplayPort-1" = [ "IV" "V" "VI" ];
        "DisplayPort-2" = [ "I" "II" "III" ];
        "HDMI-A-0" = [ "VII" "IIX" "IX" ];
      };
    };

    xsession.windowManager.bspwm.rules = {
      "discord" = {
        desktop = "^8";
      };
    };

    services.trayer.settings.monitor = 2;
  }];
}
