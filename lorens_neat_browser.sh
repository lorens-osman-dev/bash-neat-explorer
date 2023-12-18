#TODO:
bn(){
    if [ -z $1  ]; then
         echo choose file to run with bun !! 
    else
        c && bun run $1 
    fi
}
cdl(){
    if [ -z $1  ]; then
        exa --tree --level=1 --group-directories-first --icons 
    else
        cd $1 && exa --tree --level=1 --group-directories-first --icons 
    fi
}
#like cd() function but show hidden foldres and files
cdla(){
    if [ -z $1  ]; then
        exa --tree --level=1 --group-directories-first --icons -a
    else
        cd $1 && exa --tree --level=1 --group-directories-first --icons -a
    fi
}
re(){
 
    echo reloded
     exec bash
     
}
c(){
    clear
}

#--------|[ Explorer ]|--------#
e(){
    
    if [ -z $1  ]; then
        nautilus .
    else
        nautilus $1
    fi
}

#--------|[ n() function ]|--------#
n(){
    
    gnome-text-editor -i  $1
}

#--------|[ Usful Commands ]|--------#
#When you use the "cd" command without any additional information, it will automatically 
#take you to your home directory. The purpose of the "cd()" function is to cancel this behavior.


function usful_commands() {
    
    commands_file='/home/lorens/Files/usefull_commands.txt'
    header='CommandsList'
 
    
    fzf_cool="
    --border-label=$header
    --prompt=downAroww:down,upArrow:up,ESC:dimess,Enter:print_command
 
    --reverse  
    --border=sharp 
    --pointer=➜
    --disabled
    --no-info
    --height 40% 
    --no-separator
    --color=dark,hl:red:regular,fg+:white:regular,hl+:red:regular:reverse,query:white:regular,info:#cb4b16,prompt:#dd4814:bold,pointer:#dd4814:bold
    "
    if [ "$1" = "file" ]; then
    echo "Commands List file path is : $commands_file" && gnome-text-editor -i $commands_file
    elif [ "$1" = "add" ]; then
    echo "Commands List file path is : $commands_file" && gnome-text-editor -i $commands_file
    elif [ -z $1 ];then
        # grep for delete empty lines , and the lines that start with #
        #awk command to filter out lines that start with “*” or “#”
        #The sed -e 's/^[ \t]*//' part of the command will remove any spaces or tabs at the beginning of each line
        
        cat $commands_file |grep -v '^$' | grep -v '^#'|sed -e 's/^[ \t]*//'| fzf $fzf_cool |  awk '!/^[\*]/' 

      
    fi

    
  
}
alias uc="usful_commands"

#--------|[ neat_explorer ]|--------#
#When you use the "cd" command without any additional information, it will automatically 
#take you to your home directory. The purpose of the "cd()" function is to cancel this behavior.
#Note cd() invoked in neat_explorer()
cd() {
    [[ $# -eq 0 ]] && return
    builtin cd "$@"
}
# n() notepad 

function neat_explorer() {
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
                    cd "$new_selection" && neat_explorer
                elif [[ -f "$new_selection" ]]
                then
                    n "$new_selection"
                fi
        elif [[ "${#selection}" -eq 3 ]]; then
            new_selection=${selection:1}
            cd .. && neat_explorer
        else
            echo ""
        fi
    fi
  
}
alias cd="neat_explorer"
#--------|[]|--------#

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

#--------|[oh-my-posh-theme]|--------#
#eval "$(oh-my-posh init bash --config ~/oh-my-posh-theme/lorens.omp.json)"
#--------|[StarShip]|--------#

export STARSHIP_CONFIG=~/.lorens_bash/lorens_starship.toml
eval "$(starship init bash)"
