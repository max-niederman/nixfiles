{
  config,
  ...
}:

{
  config = {
    boot.plymouth = {
      enable = config.max.headed;
    };
  };
}
