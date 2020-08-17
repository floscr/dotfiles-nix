#Enables bluetooth headset using bluez5 and pulseaudio
{ pkgs, ... }:

{
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
    extraModules = [
      pkgs.unstable.pulseaudio-modules-bt
    ];
    extraConfig = ''
      load-module module-udev-detect tsched=0
      load-module module-bluetooth-policy
      load-module module-bluetooth-discover
      load-module module-switch-on-connect
    '';
    # https://medium.com/@gamunu/enable-high-quality-audio-on-linux-6f16f3fe7e1f
    daemon.config = {
      default-sample-format = "float32le";
      default-sample-rate = 48000;
      alternate-sample-rate = 44100;
      default-sample-channels = 2;
      default-channel-map = "front-left,front-right";
      default-fragments = 2;
      default-fragment-size-msec = 125;
      resample-method = "soxr-vhq";
      enable-lfe-remixing = "no";
      high-priority = "yes";
      nice-level = -11;
      realtime-scheduling = "yes";
      realtime-priority = 9;
      rlimit-rtprio = 9;
      daemonize = "no";
    };
  };

  sound.extraConfig = ''
    # Use PulseAudio plugin hw
    pcm.!default {
      type plug
      slave.pcm hw
    }
  '';

  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };

  environment.systemPackages = with pkgs; [
    unstable.playerctl
    pavucontrol
    blueman
  ];

  my.bindings = [
    {
      description = "PulseAudio Volume Control";
      categories = "Volume Control";
      command = "pavucontrol";
    }
    {
      description = "Connect Bluetooth Headphones";
      categories = "Script";
      command = "bose_connect";
    }
    {
      binding = "{ super + alt + t }";
      description = "Toggle Headphone Audio Output";
      categories = "Script, Audio";
      command = "nimx toggleHeadphoneAudioOutput";
    }
    {
      description = "Player: Metadata";
      categories = "Script, Audio";
      command = "notify-send \"$(playerctl metadata)\"";
    }
    {
      binding = "{ XF86AudioPlay, super + alt + p }";
      description = "Media: Play / Pause";
      command = "playerctl play-pause";
    }
    {
      binding = "{ XF86AudioNext, super + alt + l }";
      description = "Media: Next";
      command = "playerctl next";
    }
    {
      binding = "{ XF86AudioPrev, super + alt + h }";
      description = "Media: Previous";
      command = "playerctl previous";
    }
    {
      binding = "{ shift + XF86AudioNext, super + alt + shift + l, alt + XF86AudioRaiseVolume  }";
      description = "Media: Forward 20s";
      command = "playerctl position 20+";
    }
    {
      binding = "{ shift + XF86AudioPrev, super + alt + shift + h, alt + XF86AudioLowerVolume   }";
      description = "Media: Forward 20s";
      command = "playerctl position 20-";
    }
    {
      binding = "{ XF86AudioMute, super + alt + m }";
      description = "Sound: Mute/Unmute";
      command = "amixer -q set Master toggle";
    }
  ];
}
