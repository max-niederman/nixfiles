{ terminal, browser, launcher, flameshot }:

{
  #
  # wm-agnostic
  #

  # dunst context
  "super + i" = "dunstctl context";

  # terminal emulator
  "super + Return" = "${terminal}";

  # web browser
  "super + u" = "${browser} --new-window";
  "super + alt + u" = "${browser} --private-window";

  # program launcher
  "super + @space" = "${launcher} -show run";
  "super + alt + @space" = "${launcher} -show drun";

  # window switcher
  "alt + Tab" = "${launcher} -show window";

  # take a screenshot
  "Print" = "${flameshot} gui";

  # reload sxhkd's config
  "super + alt + Escape" = "pkill -USR1 -x sxhkd";

  #
  # bspwm
  #

  # quit/restart
  "super + alt + {q,r}" = "bspc {quit,wm -r}";

  # close and kill
  "super + {_,shift + }w" = "bspc node -{c,k}";

  # alternate between tiled and monocle
  "super + m" = "bspc desktop -l next";

  # send newest marked node to preselected node
  "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";

  # swap current node and largest window
  "super + g" = "bspc node -s biggest.window";

  #
  # state/flags
  #

  # set window state
  "super + {t,shift + t,s,f}" = "bspc node -t {tiled,psuedo_tiled,floating,fullscreen}";

  # set node flags
  "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";

  #
  # focus/swap
  #

  # focus node in given direction
  "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

  # focus node for given path jump
  "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";

  # focus next/previous window in current desktop
  "super + {_,shift + }c" = "bspc node -f {next,prev}.local.!hidden.window";

  # focus next/previous desktop
  "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";

  # focus last node/desktop
  "super + {grave,Tab}" = "bspc {node,desktop} -f last";

  # focus older or newer node in focus history
  "super + {o,i}" = ''
    bspc wm -h off; \
    bspc node {older,newer} -f; \
    bspc wm -h on
  '';

  # focus or send to given desktop
  "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

  #
  # preselect
  #

  # preselect direction
  "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";

  # preselect ratio
  "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";

  # cancel preselection for focused node
  "super + ctrl + space" = "bspc node -p cancel";

  # cancel preselection for focused desktop
  "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";

  #
  # move/resize
  #

  # expand a window's side
  "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

  # contract a window's side
  "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

  # move floating window
  "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";

  #
  # miscellaneous
  #

  # panic
  # TODO: mute all sounds
  "super + ctrl + p" = ''
    bspc desktop -f ^1; \
    bspc desktop -f ^4; \
    bspc desktop -f ^7;
  '';
}
