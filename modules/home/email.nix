{ pkgs, ... }:

{
  config = {
    accounts.email.accounts = {
      personal = {
        primary = true;

        address = "max@maxniederman.com";
        realName = "Max Niederman";

        flavor = "migadu.com";

        thunderbird.enable = true;
      };

      secondary = {
        address = "maxniederman@gmail.com";
        realName = "Max Niederman";

        flavor = "gmail.com";

        thunderbird.enable = true;
      };

      mechanize = {
        address = "max@mechanize.work";
        realName = "Max Niederman";

        flavor = "gmail.com";

        thunderbird.enable = true;
      };

      reed = {
        address = "mniederman@reed.edu";
        realName = "Max Niederman";

        flavor = "gmail.com";

        thunderbird.enable = true;
      };

      echoprize = {
        address = "max@echoprize.org";
        realName = "Max Niederman";

        flavor = "migadu.com";

        thunderbird.enable = true;
      };
    };

    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        accountsOrder = [ "personal" "secondary" "mechanize" "reed" "echoprize" ];
      };
    };
  };
}