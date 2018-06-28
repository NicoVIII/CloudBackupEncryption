# Changelog

## v0.3.0
[WIP]

## v0.2.1
### Features
* add `--verbose` flag to both libraries to extend the output
* add new name for `--hash-names`: `--name-hashing`

### Improvements/Changes
* deprecate `--hash-names`

### Fixes
* fix problems for files/directories with spaces or e.g. pluses in them

## v0.2.0
### Features
* uses argbash for better option handling and help output (have a look at -h)
* `-a` parameter for encryption, which includes hidden files and folders
* `-v` parameter for current version of libs
* hash file and folder names per default (salted: `<first encryption email>-<name>`)
* `--no-hash-names` parameter to disable hashing (see -h)

### Improvements/Changes
* redefinition of `-d` parameter for encryption (`-d 0` zips now everything in one folder, `-d 1` equals `-d 0` of v0.1.1; not providing `-d` leads to no zipping at all)
* exclude hidden files and folders by default
* improved handling of tmp-folders and if target folders already exist

### Misc
* deployment as .tar.xz with correct file permissions

## v0.1.0
Initial version of the scripts which offered basic functionality.
