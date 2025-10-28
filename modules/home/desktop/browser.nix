{ pkgs, ... }:

{
  config = {
    programs.zen-browser = {
      enable = true;

      nativeMessagingHosts = with pkgs; [
        firefoxpwa
        tridactyl-native
      ];
    };
    stylix.targets.zen-browser.profileNames = [ "Default Profile" ];

    home.file.".config/tridactyl/tridactylrc".text = ''
      " Apply catppuccin colorscheme
      colourscheme shydactyl

      "
      " Binds
      "

      " Comment toggler for Reddit, Hacker News and Lobste.rs
      bind ;c hint -Jc [class*="expand"],[class*="togg"],[class="comment_folder"]

      " GitHub pull request checkout command to clipboard (only works if you're a collaborator or above)
      bind yp composite js document.getElementById("clone-help-step-1").textContent.replace("git checkout -b", "git checkout -B").replace("git pull ", "git fetch ") + "git reset --hard " + document.getElementById("clone-help-step-1").textContent.split(" ")[3].replace("-","/") | yank

      " Git{Hub,Lab} git clone via SSH yank
      bind yg composite js "git clone " + document.location.href.replace(/https?:\/\//,"git@").replace("/",":").replace(/$/,".git") | clipboard yank

      " make t open the selection with tabopen
      bind --mode=visual t composite js document.getSelection().toString() | fillcmdline tabopen

      " Only hint search results on Google/DDG/Kagi
      bindurl www.google.com f hint -Jc #search a
      bindurl www.google.com F hint -Jbc #search a
      bindurl duckduckgo.com f hint -Jc article
      bindurl duckduckgo.com F hint -Jbc article
      bindurl kagi.com f hint -Jc .__sri-title a
      bindurl kagi.com F hint -Jbc .__sri-title a

      " Allow Ctrl-a to select all in the commandline
      unbind --mode=ex <C-a>

      " Allow Ctrl-c to copy in the commandline
      unbind --mode=ex <C-c>

      " Open right click menu on links
      bind ;C composite hint_focus; !s xdotool key Menu

      " Binds for new reader mode
      bind gr reader
      bind gR reader --tab

      " Suspend / "discard" all tabs - handy for stretching out battery life
      command discardall jsb browser.tabs.query({}).then(ts => browser.tabs.discard(ts.map(t=>t.id)))

      " New reddit is bad
      autocmd DocStart ^http(s?)://www.reddit.com js tri.excmds.urlmodify("-t", "www", "old")

      " vim: set filetype=tridactyl
    '';

    programs.chromium = {
      enable = true;
    };
  };
}
