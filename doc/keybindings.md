# List of key bindings

## Global

### Editing
* <kbd>TAB</kbd> - Mimic the normal text editor preset behavior.
* <kbd>Ctrl</kbd>+<kbd>TAB</kbd> - Reindent block.
* <kbd>Ctrl</kbd>+<kbd>d</kbd> - Kill whole line.
* <kbd>Ctrl</kbd>+<kbd>r</kbd>, <kbd>Ctrl</kbd>+<kbd>r</kbd> - Rename the whole text with the same name.
* <kbd>Ctrl</kbd>+<kbd>a</kbd> - Mark whole buffer. (Select All)

#### Build
* <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>b</kbd> - Build the program. (`build.linux`/`build.bat`/`build.mac`)

#### Run
* <kbd>f5</kbd> - Run the program. (`run.linux`/`run.bat`/`run.mac`)

### Debugging
* <kbd>f6</kbd> - Toggle `flycheck`.

### Buffer
#### Switch Buffer
* <kbd>Alt</kbd>+<kbd>b</kbd> - Switch to buffer in the current window.
* <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>b</kbd> - Switch to buffer in the other window.

#### Kill Buffer
* <kbd>Alt</kbd>+<kbd>k</kbd> - Kill current buffer.

### File
#### File Explorer
* <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>l</kbd> - Toggle file explorer.
* <kbd>Ctrl</kbd>+<kbd>b</kbd> - Toggle file explorer.

#### File Files
* <kbd>Alt</kbd>+<kbd>f</kbd> - Find file in working directory to current window.
* <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>f</kbd> - Find file in working directory to other window.
* <kbd>Ctrl</kbd>+<kbd>x</kbd>, <kbd>Alt</kbd>+<kbd>f</kbd> - Find file in project to current window.
* <kbd>Ctrl</kbd>+<kbd>x</kbd>, <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>f</kbd> - Find file in project to other window.

### Navigating
#### Navigate Cursor
* <kbd>Ctrl</kbd>+<kbd>right</kbd> - Navigate a word `right`.
* <kbd>Ctrl</kbd>+<kbd>left</kbd> - Navigate a word `left`.
* <kbd>Alt</kbd>+<kbd>right</kbd> - Navigate a word `right` excluding capital.
* <kbd>Alt</kbd>+<kbd>left</kbd> - Navigate a word `left` excluding capital..
* <kbd>Alt</kbd>+<kbd>g</kbd>, <kbd>l</kbd> - Goto line number.
* <kbd>Alt</kbd>+<kbd>g</kbd>, <kbd>c</kbd> - Goto character position.

#### Navigate Windows
* <kbd>Alt</kbd>+<kbd>w</kbd> - Switch to the `next` window.
* <kbd>Alt</kbd>+<kbd>q</kbd> - Switch to the `previous` window.

##### Vim like
* <kbd>Ctrl</kbd>+<kbd>w</kbd>, <kbd>up</kbd> - Switch to `up` window.
* <kbd>Ctrl</kbd>+<kbd>w</kbd>, <kbd>down</kbd> - Switch to `down` window.
* <kbd>Ctrl</kbd>+<kbd>w</kbd>, <kbd>right</kbd> - Switch to `right` window.
* <kbd>Ctrl</kbd>+<kbd>w</kbd>, <kbd>left</kbd> - Switch to `left` window.
##### Ace Windows
* <kbd>Alt</kbd>+<kbd>e</kbd> - Aced window. (advanced way to switch window)

##### Other
* <kbd>Ctrl</kbd>+<kbd>1</kbd> - Select window 1.
* <kbd>Ctrl</kbd>+<kbd>2</kbd> - Select window 2.
* <kbd>Ctrl</kbd>+<kbd>3</kbd> - Select window 3.
* <kbd>Ctrl</kbd>+<kbd>4</kbd> - Select window 4.
* <kbd>Ctrl</kbd>+<kbd>5</kbd> - Select window 5.
* <kbd>Ctrl</kbd>+<kbd>6</kbd> - Select window 6.
* <kbd>Ctrl</kbd>+<kbd>7</kbd> - Select window 7.
* <kbd>Ctrl</kbd>+<kbd>8</kbd> - Select window 8.
* <kbd>Ctrl</kbd>+<kbd>9</kbd> - Select window 9.

### Others

* **System**

  * <kbd>Ctrl</kbd>+<kbd>k</kbd>,<kbd>Ctrl</kbd>+<kbd>s</kbd> - Describe key bindings with current `major-mode`.
  * <kbd>Ctrl</kbd>+<kbd>k</kbd>,<kbd>Ctrl</kbd>+<kbd>i</kbd> - Describe current symbol.
  * <kbd>Ctrl</kbd>+<kbd>t</kbd> - Toggle `tabbar-mode`.
  * <kbd>Alt</kbd>+<kbd>z</kbd> - Toggle `truncate-lines'`.

* **Exit**

  * <kbd>ESC</kbd> - Exit minibuffer and go to the top level.

* **Mark**

  * <kbd>Ctrl</kbd>+<kbd>SPC</kbd> or <kbd>Alt</kbd>+<kbd>SPC</kbd> - Set mark at current point.
  * <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>;</kbd> - Pops back to the previous mark.

* **`*Scratch*`**

  * <kbd>Alt</kbd>+<kbd>s</kbd> - Open `*scratch*` buffer.
  * <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>s</kbd> - Open `*scratch*` buffer in other window.

## Web Mode

  * <kbd>Ctrl</kbd>+<kbd>Return</kbd> - Emment expand.