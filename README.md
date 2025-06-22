# GNUrdle
I'd just like to interject for a moment. What you're refering to as Worlde is in fact, GNU/Wordle, or as I've recently taken to calling it, GNU plus Wordle.
---
## What?
GNUrdle (GNU/Wordle) is like Wordle, but with UNIX commands!<br>
To use your own list, just add a `\n`-separated list of words into `words/unix.txt`.
Current list was extracted using:
```bash
$ find $(echo $PATH | tr ':' ' ') -type f -executable -printf "%f\n" 2>/dev/null | grep -x '[a-z]\{5\}' | sort -u
```
(Pipe into `wc -l` to get the amount of words!)
---
## How to compile:
```bash
$ nim compile gnurdle.nim # (`$ nim compile -r gnurdle.nim` to run it right after!)
```