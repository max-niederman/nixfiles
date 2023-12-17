
const TRANSITION_FLAGS = ["--transition-type" "grow"]

# Interactively select a wallpaper from the collection.
export def switch [path?: path] {
    let path = if ($path == null) {
        let wallpaper_dir = [$env.HOME "Pictures/Wallpapers"] | path join
        let choice = ls --short-names $wallpaper_dir | get name | input list --fuzzy
        $wallpaper_dir | path join $choice
    } else {
        $path
    }

    swww img $TRANSITION_FLAGS $path
}

# Periodically switch to a random wallpaper.
export def daemon [period: duration = 15min] {
    let wallpaper_dir = [$env.HOME "Pictures/Wallpapers"] | path join

    loop {
        let path = ls ~/Pictures/Wallpapers | shuffle | get 1.name
        swww img $TRANSITION_FLAGS $path

        sleep $period
    }
}

# Interactively select a wallpaper from the collection.
export def main [path?: path] {
    switch $path
}