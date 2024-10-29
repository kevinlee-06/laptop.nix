  {
    # Enable sleep
    systemd.targets = {
        sleep.enable = true;
        suspend.enable = true;
        hibernate.enable = true;
        hybrid-sleep.enable = true; 
    };
    powerManagement.resumeCommands = ''
        echo "[RESUMED]"
    '';
  }