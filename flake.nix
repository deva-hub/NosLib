{
  description = "Cryptographic, parsing and serialization tools for the NosTale protocol.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = { self, nixpkgs }: {
    devShell = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
      with import nixpkgs { inherit system; };
      callPackage ./shell.nix { }
    );
  };
}
