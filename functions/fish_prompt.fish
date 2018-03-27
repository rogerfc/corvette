# ⌘ git:master+ ansible $
# logo vcs:branch,dirty? dir $

function fish_prompt
    set -l last_status $status
    set -q corvette_logo; or set -l corvette_logo "⋊>"
    set -l vcs_dirty_char '+'

    set -l vcs_logo_color $fish_color_match
    set -l vcs_logo_error_color $fish_color_error
    set -l vcs_type_color $fish_color_host
    set -l vcs_branch_color $fish_color_cwd
    set -l vcs_dirty_color $fish_color_status

    set -l cmd_status_color $vcs_logo_color
    if test $last_status -ne 0
        set cmd_status_color $vcs_logo_error_color
    end

    echo -sn (set_color -o $cmd_status_color) "$corvette_logo " (set_color normal)

    get_vcs_type
    if test $vcs_type
        echo -sn " "  (set_color $vcs_type_color) $vcs_type ":"  (set_color $vcs_branch_color) $vcs_branch
        if test -n "$vcs_dirty"
            echo -sn (set_color $vcs_dirty_color) $vcs_dirty_char
        end
        echo -sn (set_color normal)
    end

    if eval $corvette_short_path
        echo -sn " " (basename (prompt_pwd))
    else
        echo -sn " " (prompt_pwd)
    end

    echo -sn (set_color -o $cmd_status_color) " \$ " (set_color normal)
end
