{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
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
    in {
      laravel = laravel {};
      laravelPhp74 = laravel { php = pkgs.php74; };
      laravelPhp80 = laravel { php = pkgs.php80; };
      laravelPhp81 = laravel { php = pkgs.php81; };
      laravelPhp82 = laravel { php = pkgs.php82; };
      laravelPhp83 = laravel { php = pkgs.php83; };
      nodejs = nodejs {};
      nodejs16 = nodejs { nodejs = pkgs.nodejs-16_x; };
      nodejs18 = nodejs { nodejs = pkgs.nodejs-18_x; };
      nodejs20 = nodejs { nodejs = pkgs.nodejs-20_x; };
      python = python {};
      python39 = python { python = pkgs.python39; };
      python310 = python { python = pkgs.python310; };
      python311 = python { python = pkgs.python311; };
      python312 = python { python = pkgs.python312; };
    });
  };
}
