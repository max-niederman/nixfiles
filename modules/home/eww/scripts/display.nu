def main [] {}

const BRIGHTNESS_PATH = /sys/class/backlight/intel_backlight/brightness
const MAX_BRIGHTNESS_PATH = /sys/class/backlight/intel_backlight/max_brightness

def "main notify" [] {
    loop {
        let brightness = (open $BRIGHTNESS_PATH | into decimal)
        let max_brightness = (open $MAX_BRIGHTNESS_PATH | into decimal)

        {
            brightness: (($brightness / $max_brightness) * 100)
        } | to json -r | print
        sleep 2sec
    }
}

def "main set-brightness" [brightness: decimal] {
    let brightness_normalized = $brightness / 100;
    let max_brightness = (open $MAX_BRIGHTNESS_PATH | into decimal)
    $brightness_normalized * $max_brightness | into string | sudo tee $BRIGHTNESS_PATH
}