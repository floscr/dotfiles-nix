#Enables bluetooth headset using bluez5 and pulseaudio
{ pkgs, ... }:

{
  #sudo rfkill unblock bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    extraConfig = ''
        ControllerMode = bredr
        [Headset]
        HFP=true
        MaxConnected=1
        FastConnectable=true
        [General]
        Disable=Headset
        AutoEnable=true
        MultiProfile=multiple
        AutoConnect=true
        Enable=Source,Sink,Media,Socket
        '';
  };
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

 # hardware.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
 #    pacmd set-card-profile 3 a2dp_sink
 #  '';

  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };

  environment.systemPackages = [
    pkgs.playerctl
    pkgs.pavucontrol
    pkgs.blueman
    pkgs.spotify
  ];
}
