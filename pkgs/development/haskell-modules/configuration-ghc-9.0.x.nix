{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC 9.0.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  libiserv = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # cabal-install needs more recent versions of Cabal and base16-bytestring.
  cabal-install = (doJailbreak super.cabal-install).overrideScope (self: super: {
    Cabal = self.Cabal_3_6_3_0;
  });

  # Jailbreaks & Version Updates

  # This `doJailbreak` can be removed once the following PR is released to Hackage:
  # https://github.com/thsutton/aeson-diff/pull/58
  aeson-diff = doJailbreak super.aeson-diff;

  async = doJailbreak super.async;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  hackage-security = doJailbreak super.hackage-security;
  hashable = overrideCabal (drv: { postPatch = "sed -i -e 's,integer-gmp .*<1.1,integer-gmp < 2,' hashable.cabal"; }) (doJailbreak (dontCheck super.hashable));
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; }) (doJailbreak super.HTTP);
  integer-logarithms = overrideCabal (drv: { postPatch = "sed -i -e 's,integer-gmp <1.1,integer-gmp < 2,' integer-logarithms.cabal"; }) (doJailbreak super.integer-logarithms);
  lukko = doJailbreak super.lukko;
  parallel = doJailbreak super.parallel;
  primitive = doJailbreak (dontCheck super.primitive);
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  singleton-bool = doJailbreak super.singleton-bool;
  split = doJailbreak super.split;
  tar = doJailbreak super.tar;
  time-compat = doJailbreak super.time-compat;
  vector = doJailbreak (dontCheck super.vector);
  vector-binary-instances = doJailbreak super.vector-binary-instances;
  vector-th-unbox = doJailbreak super.vector-th-unbox;
  zlib = doJailbreak super.zlib;
  # 2021-11-08: Fixed in autoapply-0.4.2
  autoapply = doJailbreak super.autoapply;

  doctest = dontCheck super.doctest;
  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  }) (doJailbreak super.language-haskell-extract);

  # The test suite depends on ChasingBottoms, which is broken with ghc-9.0.x.
  unordered-containers = dontCheck super.unordered-containers;

  # The test suite seems pretty broken.
  base64-bytestring = dontCheck super.base64-bytestring;

  # GHC 9.0.x doesn't like `import Spec (main)` in Main.hs
  # https://github.com/snoyberg/mono-traversable/issues/192
  mono-traversable = dontCheck super.mono-traversable;

  # Test suite sometimes segfaults with GHC 9.0.1 and 9.0.2
  # https://github.com/ekmett/reflection/issues/51
  # https://gitlab.haskell.org/ghc/ghc/-/issues/21141
  reflection = dontCheck super.reflection;

  # Disable tests pending resolution of
  # https://github.com/Soostone/retry/issues/71
  retry = dontCheck super.retry;

  # 2021-09-18: cabal2nix does not detect the need for ghc-api-compat.
  hiedb = overrideCabal (old: {
    libraryHaskellDepends = old.libraryHaskellDepends ++ [self.ghc-api-compat];
  }) super.hiedb;

  # 2021-09-18: https://github.com/haskell/haskell-language-server/issues/2206
  # Restrictive upper bound on ormolu
  hls-ormolu-plugin = doJailbreak super.hls-ormolu-plugin;

  # Too strict bounds on base
  # https://github.com/lspitzner/multistate/issues/9
  multistate = doJailbreak super.multistate;
  # https://github.com/lspitzner/butcher/issues/7
  butcher = doJailbreak super.butcher;
}
