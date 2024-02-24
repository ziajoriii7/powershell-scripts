# common-usage-examples

- [common-usage-examples](#common-usage-examples)
  * [`loltree.ps1`](#-loltreeps1-)
    + [Sane defaults](#sane-defaults)
    + [Arguments:](#arguments-)
    + [Common examples of usage](#common-examples-of-usage)
      - [basic](#basic)
      - [paths](#paths)
      - [other examples](#other-examples)



## `loltree.ps1`

Outputs a list and enumerate all files and directories within a path. It's basically a modified `ls` + minimal and sane defaults for devs writing / editing multiple files at the same time. 

I personally find it useful when you have to switch bewteen repos/directories and might just forget what code you were doing lol *(sees name above in a mysterious way)*. 

It also comes with handy arguments for this purpose. This script its meant to help developers handling their multiple files in constant writing, especially if the directory has lots of files.

With this objective in mind `loltree` does the following:
- The files and dirs are enumerated in order of last saved file.
- The color output of directories and files are easily distinguishable.
- Limits and see outputs of last written/edited files.
- It accepts relative and full paths too.
- It accepts $env paths.
- It accepts wildcards.
- All arguments come with aliases detailed below.
- It identifies if you in the root of a git repo.

### Sane defaults

It orders it by LastWriteTime and its output by default on the current path without any need of argument. For example for this `powershell-scripts` directory on my local repo its output looks like this:
```
loltree
[ 59 ] items / [ 0 ] lim
 1| SearchHistory.ps1
 2| .git [GIT Repo]
 3| GitStatusProjectsSSHonPC.ps1
 4| commandHisto.ps1
 5| script-documentation
 6| web-down.ps1
 7| ren-bunch.ps1
 8| noMagic-ipython.ps1
 9| loltree.ps1
10| win2wsl-path.ps1
11| copydir.ps1
12| web-down-start.ps1
13| touch-first.ps1
14| DownExeLast.ps1
(... some more printed output here up to the 59 items, too long too copy)
```
In this case all files are up-to-date and commited with origin/main *except* for the modified `SearchHistory.ps1` file, so you will also know which files you haven't commited your changes yet since this file appears *before* **[GIT Repo]**. Same happens with the directories if it has files inside not commited or modified to git yet. 

### Arguments:
- items:
    - `dirs` (Alias `d`): Activates the listing of directories within the specified path. When this switch is present, the script includes directories in its output.

    - `files` (Alias: `f`): Triggers the inclusion of files in the script's output. This switch parameter, when set, lists the files in the given directory path.

- limiters:
    - `start`  (Alias: `s`) : Initiates listing from the specified index. The default value is 1, indicating the script starts from the first item. This is an integer parameter that controls the starting point of item enumeration.

    - `end` (Alias: `e`): Sets the upper limit for the item count in the output. This integer parameter caps the list at the specified end index.
- others:
    - `path` (Alias: `p`): Determines the directory to be scanned by the script. Absent this parameter, the script operates in the current directory. It takes a string value representing the path.
    - `wild` (Alias: `w`): Enables filtering of the listed items based on the provided pattern. By default, it is set to "*", which means all items are included. This string parameter allows for targeted listing using wildcard characters. Useful for filtering typefiles like `-w *.ps1`.

### Common examples of usage

#### basic
If you want to limit for let's say the last 7 files or directories you basically do:
```powershell
loltree 7
```
which is exact equivalent to
```powershell
loltree -end 7
```

- list items from 4th up to the 16th.
```powershell
loltree -start 4 -end 16
```
- list items from 15th file up to the very end.
```powershell
loltree -start 15 
```

#### paths
- `loltree` accepts accepts full paths and relative paths with the argument `-path` or `-p`, no need to worry to put `""` quotations marks around it it the path has spaces, it has both: with or without quotation marks `''` theses ones too are accepted of course.

- relative path with autocompletion
```
loltree -path .\script-documentation\
```
- output:
```
[ 8 ] items / [ 0 ] lim
 1| todo-new-scripts.md
 2| PROFILE-aliases.md
 3| common-usage-examples.md
 4| image-commands-most-used.md
 5| todo-scripts-possible-solutions.md
 6| todo-scripts-errors.md
 7| todo-scripts-enhancements.md
 8| scripts-usage.md
```

- full path with limit of `2`
```
loltree -path "D:\@ziajoriii7-ggg\zsh-scripts" 2
```
- its output
```
[ 3 ] items / [ 2 ] lim
 1| .git [GIT Repo]
 2| wsl2winpath.zsh
 ```






#### other examples
- Filter out 10 last .md files
```powershell
loltree -f -w *.md 10
```

```powershell
loltree -w *.ps1 10
```


```powershell
loltree 13
```

```powershell
loltree  -w *todo*
```
