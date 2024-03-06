{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems }:
  let
    lib = nixpkgs.lib;
    eachSystem = lib.genAttrs (import systems);
    pkgsFor = eachSystem (system: nixpkgs.legacyPackages.${system});
  in {
    packages = eachSystem (system: let
      pkgs = pkgsFor.${system};
      laravel = pkgs.callPackage ./laravel;
      nodejs = pkgs.callPackage ./nodejs;
      python = pkgs.callPackage ./python;
      nginx = pkgs.callPackage ./nginx;
    in {
      laravel = laravel {};
      laravelPhp74 = laravel { php = pkgs.php74; };
      laravelPhp80 = laravel { php = pkgs.php80; };
      laravelPhp81 = laravel { php = pkgs.php81; };
      laravelPhp82 = laravel { php = pkgs.php82; };
      laravelPhp83 = laravel { php = pkgs.php83; };
      nodejs = nodejs {};
      nodejs18 = nodejs { nodejs = pkgs.nodejs_18; };
      nodejs20 = nodejs { nodejs = pkgs.nodejs_20; };
      python = python {};
      python39 = python { python = pkgs.python39; };
      python310 = python { python = pkgs.python310; };
      python311 = python { python = pkgs.python311; };
      python312 = python { python = pkgs.python312; };
      nginx = nginx {};
    });
  };
}
