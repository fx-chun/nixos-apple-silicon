self: super:
let
  pkgs = self;
  lib = pkgs.lib;

  # u-boot only works on M1 regular for now.
  # device name to DTB name list is available here:
  # https://github.com/AsahiLinux/docs/wiki/Devices
  # e.g. the M1 2020 Mac Mini's device tree name is t8103-j274
  compatibleDTs = [
    "t8103-j274"
    "t8103-j293"
    "t8103-j313"
    "t8103-j456"
    "t8103-j457"

    "t6000-j314s"
    "t6000-j316s"
    "t6001-j314c"
    "t6001-j316c"
  ];
in {
  # main scope
  nixos-m1 = lib.makeScope pkgs.newScope (self: with self; {
    m1n1 = callPackage ./m1-support/m1n1 {};
    u-boot = lib.genAttrs compatibleDTs (
      name: callPackage ./m1-support/u-boot { withDeviceTree = name; }
    );
    installer-bootstrap = callPackage ./installer-bootstrap {};
    installer-bootstrap-cross = callPackage ./installer-bootstrap {
      crossBuild = true;
    };
  });
}
