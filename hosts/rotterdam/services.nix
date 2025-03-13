{ ... }:

{
  services.keyd = {
    enable = true;
    keyboards.main = {
      ids = [ "5653:0001" ];
      settings.main = {
        esc = "overload(meta, esc)";
      };
    };
  };
}
