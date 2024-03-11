self: super: {
  vscode-extensions = super.vscode-extensions // {
    julialang.language-julia = self.vscode-utils.extensionFromVscodeMarketplace {
      name = "language-julia";
      publisher = "julialang";
      version = "1.66.2";
      sha256 = "sha256-CsrVmDOcozZ/8OV+r5SUi86LZMyQDqNk0Makmq3ayBk=";
    };
  };
}
