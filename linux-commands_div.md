# diverse linux commands to ease your linux experience
### run terminal window
<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>T</kbd>
## ![alt text][tlogo] terminator
After typing that combination you might be probalby seeing an OS default terminal. Anyway, starting one deserves an appropriate instroduction.
You can install it later if you would like to play around with all those shortcuts :

action | shortcut | description
--- | --- |---
split verticaly | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd> |
split horizontaly | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>O</kbd> |
close terminal | <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>W</kbd> | *close one pane*
switch / focus panes | <kbd>Alt</kbd>+<kbd>arrow key</kbd> | *for left \| right \| up \| down*
broadcast all | <kbd>Alt</kbd>+<kbd>A</kbd> | *feed to all terminals*
switch off broadcast | <kbd>Alt</kbd>+<kbd>O</kbd> |
copy | <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>C</kbd> | *copy selected text*
paste | <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>V</kbd> | *from clipboard*
new terminator | <kbd>Super</kbd>+<kbd>I</kbd>
new window | <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>I</kbd>
new tab | <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>T</kbd>
close tab | | *`! buggy behaviour with`* <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>W</kbd>
toggle window visibility | <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>A</kbd> | handy to know
close window | <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>Q</kbd> | *"exit"*
toggle full screen | <kbd>F11</kbd>

<sup>[check more @ launchpad][0]</sup>

## run application
<kbd>Alt</kbd>+<kbd>F2</kbd> and *'type application name'*

## search your drive
`$ find /search/this/folder/ -iname '*filename*' > ~/found 2>~/errors`

- Command arguments :

   To search on a root level use *`/`* instead *`/search/this/folder/`*. The sub directories are included.

   *`-iname`* will perform case-insensitive search

   `'filename'` goes inside quotes, wildcards `'*'` can be used

   *`>`* directing results in a file prevents polluting the terminal

   *`2>`* redirecting error stream; Typically, searching through folders you don't own will invoke *Permission denied* errors. Use **_`2>/dev/null`_** to send errors to void.

   Usefull parameters : *`-size`*, *`-atime`*

<sup>https://help.ubuntu.com/community/find</sup>

## basic file creations
*from terminal*

#### create an empty file
`$ touch newfile`

#### add some content
Using *`cat >`* will create a file ( or overwrite the file with the same name ) with the following lines of text afterwards.

`$ cat > newfile`  
`mytext`  
`and some more`  
<kbd>Ctrl</kbd>+<kbd>D</kbd>  
`$`

But *`cat >>`* will instead append the text at the end of file.

`$ cat >> newfile`  
`.. appended a few moments later`  
<kbd>Ctrl</kbd>+<kbd>D</kbd>  
`$`

#### write it somewhere ( to read it )
To *read* ~ write the file to standard output, eg. terminal type

`$ cat newfile`

*Copy* ~ write that file into another file.

`$ cat newfile > newfile-copy`

#### concatenate 
This one is nice.

`$ cat newfile - > newfile2`  
`- above is all i have ever written`  
<kbd>Ctrl</kbd>+<kbd>D</kbd>  
`$`

Check that out :

`$ cat newfile newfile2`

And to finish, concatenation the opposite way :

#### putting it all together

`$ cat - newfile newfile2 > sumup`  
`below are my last words`<kbd>&#x21B2;</kbd>  
<kbd>Ctrl</kbd>+<kbd>D</kbd>  
`$`

Just one last, but interesting command. Find out for yourself what does

`$ head sumup`

> hint : append some more lines of text into sumup and retry to head it again

Check also piping with *`less`* and *`sort`* from this nice resource :

<sup>recapped from [LINFO]</sup>

## show history from all terminals:
Add to *`.bashrc`* file :

    export PROMPT_COMMAND='history -a; history -r'

<sup>more @ [askubuntu 1] / [askubuntu 2] / [askubuntu 3]</sup>

## run a jar
>example -> java -jar runmy.jar

`$ java -jar yed.jar`

## PPA - Personal Package Archive
#### PPA's location
ppa:user/ppa-name
>example : ppa:pasgui/ppa

### add a repository to the system
>sudo add-apt-repository *ppa:user/ppa-name*

`$ sudo add-apt-repository ppa:pasgui/ppa`

### update list of latest available software from the repositories
List location : *`/etc/apt/sources.list`*

`$ sudo apt-get update`

### install software
>sudo apt-get install *toolformyOS*

`$ sudo apt-get install douml`

<sup>https://launchpad.net/+help-soyuz/ppa-sources-list.html</sup>  
<sup>check also https://help.ubuntu.com/community/Repositories/CommandLine</sup>

## Check Ubuntu release
LSB = Linux Standard Base

>lsb_release [-d|-c|-r|-a]

`$ lsb_release -d`  
`$ cat /etc/lsb-release`

more

`$ cat /etc/*release`  
`$ cat /etc/issue`  
`$ uname -a`

<sup>check @ [askubuntu 4]</sup>

## Check installed packages
Complete list

`$ dpkg --get-selections | more`

Filtered list

`$ dpkg --get-selections | grep python`

List packages matching given package-name-pattern 
>example : dpkg-query -l check*pattern

`$ dpkg-query -l python3*`

Search package with a given filename-search-pattern

`$ dpkg-query -S python3*`

List of files (locations) installed by package

`$ dpkg-query -L python3`

*`dpkg` can be used as shortcut for dpkg-query*

More useful commands :

`$ dpkg -s python3 | grep Version`  
`$ dpkg -s python3 | grep Status`

<sub>dpkg [cheatlist]</sub>

## Check available packages

List of supported package versions for particular linux distribution [http://packages.ubuntu.com/](http://packages.ubuntu.com/package name)package name

Search package by name or description

`$ apt-cache search postgresql-9.5`

## gnome system monitor
<kbd>Alt</kbd>+<kbd>F2</kbd> `"gnome-system-monitor"`

### nice approach
enter in navigator bar : "ghelp:about-ubuntu"

<kbd>Alt</kbd>+<kbd>F2</kbd> `"gnome-help ghelp:about-ubuntu"`
><sup>gave a try, but wasn't able to get it work on xubuntu 14.04</sup>

<sup>@ [askubuntu 5]</sup>

[0]:https://launchpad.net/terminator/
[askubuntu 1]: https://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals#80380 "bash-history-handling-with-multiple-terminals#80380"
[askubuntu 2]: https://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals#comment-90735 "bash-history-handling-with-multiple-terminals#comment-90735"
[askubuntu 3]: https://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals#369184 "bash-history-handling-with-multiple-terminals#369184"
[askubuntu 4]: https://askubuntu.com/questions/150917/what-terminal-command-checks-the-ubuntu-version#150947 "what-terminal-command-checks-the-ubuntu-version#150947"
[askubuntu 5]: https://askubuntu.com/questions/12493/how-can-i-find-the-version-of-ubuntu-that-is-installed#21998 "how-can-i-find-the-version-of-ubuntu-that-is-installed#21998"
[cheatlist]: http://www.cyberciti.biz/howto/question/linux/dpkg-cheat-sheet.php
[LINFO]: http://www.linfo.org/cat.html "The Linux Information Project"

[tlogo]: https://launchpadlibrarian.net/21171650/2.png "terminator never left"