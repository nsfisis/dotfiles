function fish_greeting
    if [ $COLUMNS -lt 60 ]
        echo
        set_color --bold --italic 2188a0; echo '   Hello, World!'
        set_color normal
        set_color 166caa; echo ' ~~~~~~~~~~~~~~~~'
        set_color 556a7d; echo '     ::<>'
        set_color normal
        echo
        return
    end

    echo
    set_color --bold
    set_color 2aa197; echo '   _   _      _ _         __        __         _     _ _'
    set_color 25949c; echo '  | | | | ___| | | ___    \ \      / /__  _ __| | __| | |'
    set_color 2188a0; echo '  | |_| |/ _ \ | |/ _ \    \ \ /\ / / _ \| \'__| |/ _` | |'
    set_color 1d7ea4; echo '  |  _  |  __/ | | (_) |    \ V  V / (_) | |  | | (_| |_|'
    set_color 1a75a7; echo '  |_| |_|\___|_|_|\___( )    \_/\_/ \___/|_|  |_|\__,_(_)'
    set_color 166caa; echo '                      |/'
    echo
    set_color normal
    set_color 166caa; echo ' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    set_color 556a7d; echo '              ::<>       ::<>  ::<>'
    set_color 556a7d; echo '          ::<>     ::<>   ::<>      ::<>'
    set_color 556a7d; echo '              ::<>      ::<>  ::<>   ::<>'
    set_color 556a7d; echo '            ::<>    ::<>        ::<>'
    echo
end
