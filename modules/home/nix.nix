{ osConfig, ... }:

{
  config = {
    nixpkgs = {
      inherit (osConfig.nixpkgs) config;
    };
  };
}
