{ pkgs, ... }:
{
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;
  
  # Basic locale
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
}
