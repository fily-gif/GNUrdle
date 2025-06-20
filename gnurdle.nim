import std/random
import std/strformat
import strutils

randomize()
const file = "words/words.txt"
const word = readFile(file)
const filesplit = splitLines(word)
var randword = filesplit[rand(filesplit.len)]

echo(&"reading from {file}...")
echo(&"loaded {filesplit.len} lines...");
echo(&"random word: {randword}") # debug!
proc main() = 
    echo("guess the word!")
    echo(&"({randword})") # sanity checking, the word changes if incorrect, but last word still prints out???
    echo("_ _ _ _ _")
    var input = readLine(stdin)
    while true:
        if input.len < 5:
            echo("your input is fewer than 5 characters!")
            break
        elif input.len > 5:
            echo("your input is bigger than 5 characters!")
            break
        elif input == randword:
            echo(&"correct! the word is: {randword}")
            break
        else:
            echo(&"incorrect! the word was: {randword}")
            main()

main()