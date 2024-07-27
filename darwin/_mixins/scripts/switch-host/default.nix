{ pkgs, ... }:
let
  name = builtins.baseNameOf (builtins.toString ./.);
  shellApplication = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      bc
      coreutils-full
    ];
    text = builtins.readFile ./${name}.sh;
  };
in
{
  environment.systemPackages = with pkgs; [ shellApplication ];
}
