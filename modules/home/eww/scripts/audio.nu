def main [] {}

def "main notify" [] {
    loop {
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | {
            volume: ($in | str substring 8..12 | into decimal | $in * 100)
            muted: ($in | str contains "MUTED")
        } | to json -r | print
        sleep 1sec
    }
}

def "main set-volume" [volume: decimal] {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ ($volume / 100)
}

def "main toggle-mute" [] {
    # TODO
}