# Git Commands

## Git basic:
```
1. git clone (repo link)                     // to clone repository
2. git status                                // to check status of files
3. git add (file name)                       // to add new files to repo
4. git add *                                 // to add all new files
5. git rm (file name)                        // to delete files
6. git restore (file name)                   // to restore files
```
```
7. git restore --staged (file name)          // to restore from staged
8. git clean -n                              // to show files will be del
9. git clean -f                              // to delete files from staged
```
```
10. git reset Head (file name)               // to delete committed file 
11. git commit -m "Description"              // to commit changes
12. git push                                 // to push to repo
13. git push origin master                   // to push to master
14. git push origin master --force           // to force push to master
15. git push -u origin master                // -u to auto poll and push
```

## Delete commits:
```
1. git log                                  // to show commits list
2. git reset --hard (commit no.)            // to delete next commits
3. git push origin master --force           // to update branch forcefully
```

## Git branch:
```
1. git branch                               // to see branches
2. git branch (branch name)                 // to create br
3. git branch -d (branch name)              // to safely delete br
4. git branch -D (branch name)              // to forcefully delete br
5. git branch -m (new br name)              // to rename a br
6. git branch -M (new br name)              // to force rename br
7. git branch -v                            // to see br list with commit
8. git branch -a                            // to see brs list in local and remote brs
```

## Git checkout:
```
1. git checkout -b (branch name)             // create and move to br
2. git checkout (branch name)                // to move to br
3. git checkout master                       // to move to master
```
```
1. git remote -v                             // to locate remote name
2. git pull origin (br name)                 // to pull new changes
```

## Git config:
```
1. git config --global user.name             // to specify user name
2. git config --global user.email            // to specify user email
3. git config --global core.editor "nano"    // set nano as editor
4. git config --global --edit                // to edit config details
5. git config --global alias.st status       //create short command
6. git config --global alias.br branch       // create short br
```

## SSH:
```
1. ssh-keygen -t rsa -b 4096 -C "email id"   //create pub key
2. ssh-add -l                                // to show list of pub keys
3. ssh -T git@github.com                     // to test connection to ssh
4. git remote add origin git@github.com:(GitHub username)/(repo name).get      // add origin
5. git remote remove origin                  // to remove origin
```
```
1.git merge (branch name)                    // to merge br from another br
```

## Stash:
```
1. git stash                                // to hide files before commit
2. git stash pop                            // to show hidden file in stash
3. git stash pop stash@{no.}                // to show file no. in stash
4. git stash apply                          // to show hidden file without remove
5. git stash list                           // to show list of stash files 
6. git stash save "Description              // to hide file with desc
7. git stash drop                           // to delete last file in stash
8. git stash drop stash@{no.}               // to delete file no. in stash
9. git stash show                           // to show details of last file
10. git stash show stash@{no.}              // to show details of file no.
11. git stash clear                         // to delete all files in stash 
```
