function prompt_jobs
    set njobs (jobs -p | wc -l)
    if [ $njobs -gt 0 ]
        echo -n "$argv$njobs"
    end
end

function prompt_git_describe
    git describe "--dirty="(set_color -o magenta)"*" --all ^/dev/null \
        | sed "s/^[^/]*\///"
end

function prompt_acpi
    # TODO
end

function fish_prompt
    # reset DEL key everytime the prompt is printed
    if [ "$TERM" = "st-256color" ]
        echo -n (tput smkx) > /dev/tty  
    end

    echo
    set_color -o green ; echo -n (hostname | cut -d . -f 1)" "
    set_color    normal; echo -n "["
    set_color    normal; echo -n (prompt_jobs "j"(set_color -o yellow))
    set_color    normal; echo -n (prompt_acpi "B"(set_color -b blue  ))
    set_color    normal; echo -n "] "
    set_color    purple; echo -n (date "+%R")" "
    set_color -o blue  ; echo -n (prompt_pwd)" "
    set_color    cyan  ; echo -n (prompt_git_describe)

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

