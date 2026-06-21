final: prev: {
  typst2commonmark = {
    to-commonmark = final.callPackage ./package.nix { };
    default = final.typst2commonmark.to-commonmark;
  };
}
