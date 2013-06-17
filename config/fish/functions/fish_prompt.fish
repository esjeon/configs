function prompt_status
    echo -n '['

    if [ $argv[1] -ne 0 ]
        printf "s%s" (set_color red; echo $argv[1])
        set_color normal
    end

    set njobs (jobs -p | wc -l)
    if [ $njobs -gt 0 ]
        printf "j%s" (set_color -o green; echo $njobs)
        set_color normal
    end

    echo -n ']'
end

function fish_prompt
    # reset DEL key everytime the prompt is printed
    if [ "$TERM" = "st-256color" ]
        echo -n (tput smkx) > /dev/tty  
    end

    set -l ret $status
    printf '\n%s %s %s %s' \
        (set_color -o green ; hostname | cut -d . -f 1) \
        (set_color    normal; prompt_status $ret) \
        (set_color    purple; date "+%X") \
        (set_color -o blue  ; prompt_pwd)

    # print ROOT if root
    if [ "$USER" = root ]
        set_color -o red
        echo -ne "\n ROOT # "
    else
        set_color blue
        echo -ne "\n \$ "
    end

    # reset color
    set_color normal
end

