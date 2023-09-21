# bash_neat_explorer

Some functions that help with filesystem navigation in bash terminal in Windows WSL.

## e() function

The `e()` function is a bash function designed to run Windows Explorer to navigate WSL directories. It has the following features:

- If you don't provide an argument, Windows Explorer will open in the current directory in the bash command line.
- If the argument is a file, Windows Explorer will open the corresponding Windows program to open the file.

### How To Use

To use the `e()` function, you can copy it to your `.bashrc` file.

```bash
e(){
    app="/mnt/c/Windows/explorer.exe"
    if [ -z $1  ]; then
        $app .
    else
        $app $1
    fi
}
```
#### Usage Examples

Here's an example of how you can use it:
```bash
# Open Windows Explorer in the current directory
e

# Open Windows Explorer in a specific directory
e directory

# Open a file with its associated Windows program
e file.txt
```



## n() function

The `n()` function will open specific file in windows notepad app .

### How To Use

To use the `n()` function, you can copy it to your `.bashrc` file.

```bash
n(){
    app="/mnt/c/Windows/notepad.exe"
    $app $1
}
```
#### Usage Examples

Here's an example of how you can use it:
```bash

# open specific file in windows notepad app
n file.txt
```



## neat_explorer() function

The `neat_explorer()` function is a neat command-line tool that allows you to navigate the file system with ease. It modifies the normal behavior of the `cd` command  when you don't enter any argument, instead of taking you to the user's home directory, it will launch a browsing mode .
 In browsing mode, you can use the arrow keys to move around the directories and files, and press Enter to change directory or open a file with the corresponding Windows program. You can also use the fuzzy search to find what you need. To exit browsing mode, just press Esc. The function preserves the other functionalities of the `cd` command, such as changing directories with arguments or using shortcuts like `cd ..` or ` cd ~`.

### Screenshots

>inside vscode terminal
>
![neat explorer vscode terminal](https://github.com/lorens-osman-dev/bash-neat-explorer/blob/assets/neat%20explorer_vscode_terminal.png?raw=true)
>inside windows WSL terminal
>
![neat explorer windows terminal](https://github.com/lorens-osman-dev/bash-neat-explorer/blob/assets/neat%20explorer%20windows%20terminal.png?raw=true)

### How To Use

1. You need   [exa](https://the.exa.website/),  [fzf](https://github.com/junegunn/fzf) and `e()` function.
> **exa** install 
> > `sudo apt install exa`
> 
> **fzf** install
> >`brew install fzf` or
> >`sudo apt install fzf`
>
>**e()** install
>> check last section.

2. Copy the **functions**  to your `.bashrc` file.
  

```bash
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
                    e "$new_selection"
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

```

#### Usage Examples

Here's an example of how you can use it:

```bash
# just type cd without argument and start navigation
cd

# if you typed any argument the function will behave like normal cd command
cd .
cd foo
cd foo/bar

```



## neat_history() function

The `neat_history()` function is a neat tool for enhancing your command line experience in Bash. It provides an interactive interface to navigate through your command history, allowing you to easily find and reuse past commands.

The interface is intuitive and easy to use. Simply press the `TAB` key to enter the choosing mode. You can then navigate through the options by pressing `TAB` to move down or `Q` to move up. To confirm your selection, press `SPACE`. If you want to exit the menu, just press `ESC`.

Once a command is selected, it’s placed on your command line, ready for execution or further editing. This function is a great addition to any developer’s toolkit, making command line navigation faster and more efficient.

### Screenshots

>inside vscode terminal
>
![neat history vs code terminal](https://github.com/lorens-osman-dev/bash-neat-explorer/blob/assets/neat%20history_vscode_terminal.png?raw=true)
>inside windows WSL terminal
>
![neat history windows terminal](https://github.com/lorens-osman-dev/bash-neat-explorer/blob/assets/neat%20history%20windows%20%20terminal.png?raw=true)

### How To Use

1. You need  [fzf](https://github.com/junegunn/fzf).
 
> **fzf** install
> >`brew install fzf` or
> >`sudo apt install fzf`
>


2. Copy the **functions**  to your `.bashrc` file.
  

```bash
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
    local result=$(history | sort -r| awk '{$1=""; if (!seen[$0]++) print $0}'| fzf   --prompt="TAB: ↓  Q: ↑  SPACE: Choose ESC: Close" $fzf_options)
    READLINE_LINE="${result# }"
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\t": neat_history'

```




## neat_history_search() function

The `neat_history_search` function is a neat tool for Bash users that enhances the command line experience by providing  interactive search tool for your command history.

To use this function, press `ctrl+h` to enter the history search mode. You can then type any string to search through your command history. Navigate through the search results by pressing `TAB` or `down arrow ↓` to move down, or `up arrow ↑` to move up. Confirm your selection by pressing `enter`. If you want to exit the menu, just press `ESC`.

Once a command is selected, it’s placed on your command line, ready for execution or further editing. This function is a great addition to any developer’s toolkit, making command line navigation faster and more efficient.

### Screenshots

>inside vscode terminal
>
![neat history search vs code terminal](https://github.com/lorens-osman-dev/bash-neat-explorer/blob/assets/neat%20history%20search_vscode_terminal.png?raw=true)
>inside windows wsl terminal
>
![neat history search windows terminal](https://github.com/lorens-osman-dev/bash-neat-explorer/blob/assets/neat%20history%20search%20windows%20terminal.png?raw=true)

### How To Use

1. You need  [fzf](https://github.com/junegunn/fzf).
 
> **fzf** install
> >`brew install fzf` or
> >`sudo apt install fzf`
>


2. Copy the **functions**  to your `.bashrc` file.
  

```bash
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

```



