{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      videoDrivers = ["nvidia"];
    };
  };

# GPU 
  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
      ];
    };
    nvidia =  {
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "550.127.05";
        sha256_64bit = "sha256-04TzT10qiWvXU20962ptlz2AlKOtSFocLuO/UZIIauk=";
        sha256_aarch64 = "sha256-mVEeFWHOFyhl3TGx1xy5EhnIS/nRMooQ3+LdyGe69TQ=";
        openSha256 = "sha256-Po+pASZdBaNDeu5h8sgYgP9YyFAm9ywf/8iyyAaLm+w=";
        settingsSha256 = "sha256-cUSOTsueqkqYq3Z4/KEnLpTJAryML4Tk7jco/ONsvyg=";
        persistencedSha256 = "sha256-Vz33gNYapQ4++hMqH3zBB4MyjxLxwasvLzUJsCcyY4k=";
      };
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      #dynamicBoost.enable = true;
      #powerManagement.enable = true;
      powerManagement.finegrained = true;
      #nvidiaPersistenced = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}