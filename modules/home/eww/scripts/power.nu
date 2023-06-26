const ICONS = {
    discharging: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    charging:    ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
}

def main [] {}

def "main notify" [] {
    loop {
        let level = (open /sys/class/power_supply/BAT0/capacity | into decimal | $in / 100)
        let charging = (open /sys/class/power_supply/AC/online | into bool)
        {
            level: ($level * 100)
            charging: $charging
            icon: (if $charging { $ICONS.charging } else { $ICONS.discharging } | get ($level * 10 | math ceil | $in - 1))
        } | to json -r | print
        sleep 2sec
    }
}