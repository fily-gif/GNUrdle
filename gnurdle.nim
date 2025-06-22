import std/random
import std/strformat
import strutils
import terminal # styledEcho(bgBlue, fgRed, "Color echo")

randomize()
const fn = "words/words.txt"
const file = readFile(fn)
const filesplit = splitLines(file)

echo(&"reading from {file}...")
echo(&"loaded {filesplit.len} lines...");

proc colorizeword(word: string, target: string, status: int) = 
    type Status = enum Green, Yellow, Gray
    type Word = string
    var statuses: array[5, Status]
    var words: array[6, Word]
    for i in 0 ..< word.len:
        if word[i] == target[i]:
            echo(i)

proc main() = 
    echo("guess the word!")
    let target = filesplit[rand(filesplit.len)]
    echo(&"({target})") # FIXME: sanity checking, the word changes if incorrect, but last word still prints out???
    echo("_ _ _ _ _")
    var input = readLine(stdin)
    while true:
        if input.len < 5:
            echo("your input is fewer than 5 characters!")
            break
        elif input.len > 5:
            echo("your input is bigger than 5 characters!")
            break
        elif input == target:
            echo(&"correct! the word is: {target}")
            break
        else:
            echo(&"incorrect! the word was: {target}")
            main()

colorizeword("testy", "tesyy", 0)