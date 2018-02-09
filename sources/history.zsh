zmodload zsh/parameter

function zaw-copy-to-clipboard() {
    if [[ "${OSTYPE:l}" == darwin* && $+commands[pbcopy] ]]; then
        pbcopy<<<"${(j:; :)@}"
    elif [[ "${OSTYPE:l}" == linux* && $+commands[xclip] ]]; then
        xclip -i<<<"${(j:; :)@}"
    fi
}

function zaw-src-history() {
    if zstyle -t ':filter-select' hist-find-no-dups ; then
        candidates=(${(@vu)history})
        src_opts=("-m" "-s" "${BUFFER}")
    else
        cands_assoc=("${(@kv)history}")
        # have filter-select reverse the order (back to latest command first).
        # somehow, `cands_assoc` gets reversed while `candidates` doesn't.
        src_opts=("-r" "-m" "-s" "${BUFFER}")
    fi
    actions=("zaw-callback-execute" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")

    if (( $+functions[zaw-bookmark-add] )); then
        # zaw-src-bookmark is available
        actions+="zaw-bookmark-add"
        act_descriptions+="bookmark this command line"
    fi

    if [[ "${OSTYPE:l}" == darwin* && $+commands[pbcopy] ]] || [[ "${OSTYPE:l}" == linux* && $+commands[xclip] ]]; then
        # zaw-copy-to-clipboard is available
        actions+="zaw-copy-to-clipboard"
        act_descriptions+="copy to clipboard"
    fi
}

zaw-register-src -n history zaw-src-history
