if [ -n "$CLAUDECODE" ]; then
    # Safe wrapper for find command
    find() {
        has_dangerous=0

        for arg in "$@"; do
            case "$arg" in
                -delete|-exec|-execdir|-fls|-fprint|-fprint0|-fprintf|-ok|-okdir)
                    has_dangerous=1
                    break
                    ;;
            esac
        done

        if [ $has_dangerous = 1 ]; then
            echo "Error: dangerous actions, -delete/-exec/-execdir/-fls/-fprint/-fprint0/-fprintf/-ok/-okdir, are not allowed in Claude Code environment" >&2
            return 1
        fi

        command find "$@"
    }

    # Safe wrapper for fd command
    fd() {
        has_dangerous=0

        for arg in "$@"; do
            case "$arg" in
                -x|--exec|-X|--exec-batch)
                    has_dangerous=1
                    break
                    ;;
            esac
        done

        if [ $has_dangerous = 1 ]; then
            echo "Error: dangerous actions, -x/--exec/-X/--exec-batch, are not allowed in Claude Code environment" >&2
            return 1
        fi

        command fd "$@"
    }
fi
