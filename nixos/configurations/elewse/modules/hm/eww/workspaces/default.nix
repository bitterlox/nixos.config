{ pkgs, ... }:
let
  scripts = (import ./scripts { inherit pkgs; });

  get-workspaces = "${scripts}/bin/get-workspaces.sh";
  get-active-workspace = "${scripts}/bin/get-active-workspace.sh";
  change-active-workspace = "${scripts}/bin/change-active-workspace.sh";
  get-window-title = "${scripts}/bin/get-window-title.sh";

in pkgs.writeTextFile {
  name = "workspaces.eww";
  text = ''
    (deflisten workspaces :initial "[]" "${pkgs.bash}/bin/bash ${get-workspaces}")

    (deflisten current_workspace :initial "1" "${pkgs.bash}/bin/bash ${get-active-workspace}")

    (defwidget workspaces []
      (eventbox :onscroll "${pkgs.bash}/bin/bash ${change-active-workspace} {} ''${current_workspace}" :class "workspaces-widget"
        (box :space-evenly true
          (label :text "''${workspaces}''${current_workspace}" :visible false)
          (for workspace in workspaces
            (eventbox :onclick "hyprctl dispatch workspace ''${workspace.id}"
              (box :class "workspace-entry ''${workspace.id == current_workspace ? "current" : ""} ''${workspace.windows > 0 ? "occupied" : "empty"}"
                (label :text "''${workspace.id}")
                )
              )
            )
         )
      )
    )

    (deflisten window :initial "..." "${pkgs.bash}/bin/bash ${get-window-title}")

    (defwidget window_w []
      (box
        (label :text "''${window}")
      )
    )

    (defwindow bar
      :monitor 0
      :windowtype "dock"
      :geometry (geometry :x "0%"
                          :y "0%"
                          :width "90%"
                          :height "10px"
                          :anchor "top center")
      :reserve (struts :side "top" :distance "4%")
      (box
        (window_w)
        (workspaces)))
  '';
  #  executable = true;
  #  destination = "/bin/my-file";
}
