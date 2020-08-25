function fish_prompt --description 'Write out the prompt'
    #Save the return status of the previous command
    set stat $status

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __fish_color_blue
        set -g __fish_color_blue (set_color -o blue)
    end
    if not set -q __git_cb
        set __git_cb "["(set_color brown)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)"]"
    end

    if not set -q __fish_prompt_time
        set __fish_prompt_time "["(set_color red)(date +'%H:%M:%S')(set_color normal)"]"
    end

    #Set the color for the status depending on the value
    set __fish_color_status (set_color -o green)
    if test $stat -gt 0
        set __fish_color_status (set_color -o red)
    end

    switch "$USER"

        case root toor

            if not set -q __fish_prompt_cwd
                if set -q fish_color_cwd_root
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
                else
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
                end
            end

            printf '%s@%s %s%s%s# ' $USER (prompt_hostname) "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

        case '*'

            if not set -q __fish_prompt_cwd
                set -g __fish_prompt_cwd (set_color $fish_color_cwd)
            end

            printf '%s %s%s@%s:%s%s\n%s(%s)%s %s \f\r$ ' "$__fish_prompt_time" "$__fish_color_blue" $USER (prompt_hostname) "$__fish_prompt_cwd" (prompt_pwd) "$__fish_color_status" "$stat" "$__fish_prompt_normal" "$__git_cb"

    end
    set -l project

    if echo (pwd) | grep -qEi "^/home/$USER/git/"
        set project (echo (pwd) | sed "s#^/git/$USER/git/\\([^/]*\\).*#\\1#")
    else
        set project "Terminal"
    end

    wakatime --write --plugin "fish-wakatime/0.0.1" --entity-type app --project "$project" --entity (echo $history[1] | cut -d ' ' -f1) 2>&1 >/dev/null &
end
