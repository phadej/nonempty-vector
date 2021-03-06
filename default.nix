{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, Cabal, cabal-doctest, deepseq, doctest
      , primitive, semigroups, stdenv, vector
      }:
      mkDerivation {
        pname = "nonempty-vector";
        version = "0.2.0.1";
        src = ./.;
        setupHaskellDepends = [ base Cabal cabal-doctest ];
        libraryHaskellDepends = [
          base deepseq primitive semigroups vector
        ];
        testHaskellDepends = [ base doctest ];
        homepage = "https://github.com/emilypi/nonempty-vector";
        description = "Non-empty vectors";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
