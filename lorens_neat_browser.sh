#--------|[ Explorer ]|--------#
e(){
    app="/mnt/c/Windows/explorer.exe"
    if [ -z $1  ]; then
        $app .
    else
        $app $1
    fi
}

#--------|[ n() function ]|--------#
n(){
    app="/mnt/c/Windows/notepad.exe"
    $app $1
}

#--------|[ bash_neat_explorer ]|--------#
#When you use the "cd" command without any additional information, it will automatically 
#take you to your home directory. The purpose of the "cd()" function is to cancel this behavior.
#Note cd() invoked in bash_neat_explorer()
cd() {
    [[ $# -eq 0 ]] && return
    builtin cd "$@"
}
# n() notepad 

function bash_neat_explorer() {
    fzf_cool="
    --height 40% --reverse  --border=sharp       
    --info=inline
    --pointer=→
    --color=fg:#839496,bg+:#242424,spinner:#719e07,hl+:#5fff87,disabled:#ce392c   
    --color=header:#586e75,info:#cb4b16,pointer:#5fff87   
    --color=marker:#719e07,fg+:#839496,prompt:#5fff87,hl:#719e07
    "
    cd $1
    if [ -z $1 ];
    then
        selection="$(exa --tree --level=1 --group-directories-first --icons -a | fzf --header=$(pwd) $fzf_cool)"
        if [[ "${#selection}" -gt 6 ]]; then
            new_selection=${selection:6}
            if [[ -d "$new_selection" ]]
                then
                    cd "$new_selection" && bash_neat_explorer
                elif [[ -f "$new_selection" ]]
                then
                    e "$new_selection"
                fi
        elif [[ "${#selection}" -eq 3 ]]; then
            new_selection=${selection:1}
            cd .. && bash_neat_explorer
        else
            echo ""
        fi
    fi
  
}
alias cd="bash_neat_explorer"
#--------|[]|--------#