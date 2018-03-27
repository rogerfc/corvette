# adapted from somewhere else, cannot find the original reference

function get_vcs_type

    function __fast_find_git_root
        git rev-parse --show-toplevel > /dev/null 2>&1
    end

    function __fast_git_dirty
        test (count (git status --porcelain)) != 0
    end

    function __fast_git_branch
        git rev-parse --abbrev-ref HEAD
    end

    function __fast_find_hg_root
        set -l dir (pwd)
        set -e HG_ROOT

        while test $dir != "/"
            if test -f $dir'/.hg/dirstate'
                set -g HG_ROOT $dir"/.hg"
                return 0
            end
            set -l dir (dirname $dir)
        end

        return 1
    end

    function __fast_hg_dirty
        test (count (hg status --cwd $HG_ROOT)) != 0
    end

    function __fast_hg_branch
        cat "$HG_ROOT/branch" 2>/dev/null
        or hg branch
    end

    if __fast_find_git_root
        set -g vcs_type 'git'
    else if __fast_find_hg_root
        set -g vcs_type 'hg'
    else
        set -e vcs_type
    end

    if test $vcs_type
        switch $vcs_type
        case git
            set -g vcs_branch (__fast_git_branch)
            __fast_git_dirty; and set -g vcs_dirty "dirty"; or set -e vcs_dirty
        case hg
            set -g vcs_branch (__fast_hg_branch)
            __fast_hg_dirty; and set -g vcs_dirty "dirty"; or set -e vcs_dirty
        case '*'
            return 1
        end
  end

end
