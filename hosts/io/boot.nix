{ ... }:

{
  boot = {
    # TODO check if future kernel versions fix boot issue with systemd initrd with tpm
    initrd.systemd.tpm2.enable = false;
    kernelParams = [
      "nosgx"
      "i915.fastboot=1"
      "mem_sleep_default=deep"
    ];
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
    '';
  };
}
