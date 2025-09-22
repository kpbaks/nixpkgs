{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.perses;
  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "perses.yaml" cfg.settings;
in
{
  # TODO: see how services.grafana is configured
  options.services.perses = {
    enable = lib.mkEnableOption "";
    package = lib.mkPackageOption pkgs "perses" { };
    # https://perses.dev/perses/docs/configuration/configuration/#configuration-file
    # settings =

    # settings.readonly = true;

    # TODO:
    # auth

    # TODO:
    # https://perses.dev/perses/docs/concepts/dashboard-as-code/
    # dashboards

    # TODO:
    # https://perses.dev/perses/docs/concepts/plugin/
    # plugins

    # plugins = with perses.plugins; [

    # ];

    # TODO:
    # https://perses.dev/perses/docs/concepts/datasource/
    # datasources:

    # datasources.tempo.enable = config.services.tempo.enable;
    # datasources.prometheus.enable = config.services.prometheus.enable;
  };

  config = lib.mkIf cfg.enable {
    systemd.services.perses = {
      wantedBy = [ "multi-user.target" ];
      ExecStart = utils.escapeSystemdExecArgs ([
        (lib.getExe cfg.package)
      ]);

    };
  };
}
