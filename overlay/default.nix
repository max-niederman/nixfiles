self: super: {
  garamond-premier-pro = self.callPackage ./garamond-premier-pro { };
  princexml = self.callPackage ./princexml { };
  waystt = self.callPackage ./waystt { };

  vscode-extensions =
    super.vscode-extensions
    // (with self.vscode-utils; {
      icrawl.discord-vscode = extensionFromVscodeMarketplace {
        name = "discord-vscode";
        publisher = "icrawl";
        version = "5.8.0";
        sha256 = "sha256-IU/looiu6tluAp8u6MeSNCd7B8SSMZ6CEZ64mMsTNmU=";
      };
    });
}
