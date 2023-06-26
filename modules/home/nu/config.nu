let carapace_completer = { |spans| carapace $spans.0 nushell $spans | from json }

let-env config = {
    show_banner: false
    completions: {
        external: {
            enable: true
            completer: $carapace_completer
        }
    }
}