self: super: {
  vscode-extensions = super.vscode-extensions // (with self.vscode-utils; {
    julialang.language-julia = extensionFromVscodeMarketplace {
      name = "language-julia";
      publisher = "julialang";
      version = "1.66.2";
      sha256 = "sha256-CsrVmDOcozZ/8OV+r5SUi86LZMyQDqNk0Makmq3ayBk=";
    };
    
    icrawl.discord-vscode = extensionFromVscodeMarketplace {
      name = "discord-vscode";
      publisher = "icrawl";
      version = "5.8.0";
      sha256 = "sha256-IU/looiu6tluAp8u6MeSNCd7B8SSMZ6CEZ64mMsTNmU=";
    };
  });
}
