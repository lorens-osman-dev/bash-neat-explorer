#TODO:
#[ ] documment 
#[ ] uodate the picturs in readme
#[ ] update neat explorer in readme
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
    # --border-label=lorens
    info_inline_seprator=']'
    fzf_cool="
    --reverse  
    --border=sharp 
    --height 40%       
    --info=inline:$info_inline_seprator
    --separator=""
    --prompt=[
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


#--------|[ neat_history_search ]|--------#
bind -r '\C-h'
neat_history_search(){
    local info_inline_seprator=']'
    local fzf_options="
    --reverse
    --bind=tab:down,btab:up  
    --history-size=5000
    --height 40% 
    --info=inline:$info_inline_seprator
    --separator=""
    --prompt=[
    --border=none      
    --pointer=•
    --color=dark,hl:red:regular,fg+:white:regular,hl+:red:regular:reverse,query:white:regular,info:#cb4b16,prompt:red:bold,pointer:red:bold
    "
    local cmmand_line_text=$READLINE_LINE
    local result=$(history | sort -r| awk '{$1=""; if (!seen[$0]++) print $0}'| fzf --query="^$cmmand_line_text" $fzf_options)
    READLINE_LINE="${result# }"
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-h": neat_history_search'



#--------|[ neat_hisory ]|--------#
bind -r '\t'
neat_history(){
    local fzf_options="
    --disabled
    --reverse
    --bind=tab:down,q:up,space:accept
    --height 40% 
    --no-info
    --no-separator

    --border=none      
    --pointer=• 
    --color=dark,hl:red:regular,fg+:white:regular,hl+:red:regular:reverse,query:white:regular,info:#cb4b16,prompt:#dd4814:bold,pointer:#dd4814:bold
    "
    local cmmand_line_text=$READLINE_LINE

    local result=$(history | sort -r| awk '{$1=""; if (!seen[$0]++) print $0}'| fzf   --prompt="TAB: ↓  Q: ↑  SPACE: Choose  ESC: Close" $fzf_options)
    READLINE_LINE="${result# }"
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\t": neat_history'


#--------|[oh-my-posh-theme]|--------#
#eval "$(oh-my-posh init bash --config ~/oh-my-posh-theme/lorens.omp.json)"
#--------|[StarShip]|--------#
export STARSHIP_CONFIG=~/lorens_bash/new.toml
eval "$(starship init bash)"
