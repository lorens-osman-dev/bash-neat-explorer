# lorens_neat_browser

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



## lorens_neat_browser() function

The `lorens_neat_browser()` function is a neat command-line tool that allows you to navigate the file system with ease. It modifies the normal behavior of the `cd` command  when you don't enter any argument, instead of taking you to the user's home directory, it will launch a browsing mode .
 In browsing mode, you can use the arrow keys to move around the directories and files, and press Enter to change directory or open a file with the corresponding Windows program. You can also use the fuzzy search to find what you need. To exit browsing mode, just press Esc. The function preserves the other functionalities of the `cd` command, such as changing directories with arguments or using shortcuts like `cd ..` or ` cd ~`.

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
function lorens_neat_browser() {
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
                    cd "$new_selection" && lorens_neat_browser
                elif [[ -f "$new_selection" ]]
                then
                    e "$new_selection"
                fi
        elif [[ "${#selection}" -eq 3 ]]; then
            new_selection=${selection:1}
            cd .. && lorens_neat_browser
        else
            echo ""
        fi
    fi
  
}
alias cd="lorens_neat_browser"

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