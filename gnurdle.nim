import std/random
import std/strformat
import strutils
import terminal

randomize()
const fn = "words/unix.txt"
const file = readFile(fn)
const filesplit = splitLines(file)

echo(&"reading from {fn}...")
echo(&"loaded {filesplit.len} lines...")

type Status = enum Green, Yellow, Gray

proc colorizeword(word: string, target: string) = 
    var statuses: array[5, Status] # why do arrays in nim have to be so weird omfg
    var used: array[5, bool]

    # first pass
    for i in 0 ..< 5:
        if word[i] == target[i]:
            statuses[i] = Green # correct
            used[i] = true # adds to the array of used letters so that words like "refer" dont cause an edge-case
        else:
            statuses[i] = Gray # checked over in the second pass

    # second pass
    for i in 0 ..< 5:
        if statuses[i] == Gray: # checking over every "invalid" letter so far...
            for j in 0 ..< 5:
                if not used[j] and word[i] == target[j]:
                    statuses[i] = Yellow # wasnt used, exists in `target`
                    used[j] = true
                    break

    for i in 0 ..< 5:
        case statuses[i]
        of Green: stdout.styledWrite(fgBlack, bgGreen, $word[i])
        of Yellow: stdout.styledWrite(fgBlack, bgYellow, $word[i])
        of Gray: stdout.styledWrite(fgWhite, bgRed, $word[i]) # supposed to be gray but i cba to rewrite yacpl into nim lmao

proc main() = 
    echo("Guess the UNIX command! (5 letters, 6 attempts)")
    let target = filesplit[rand(filesplit.len)] # suprisingly fast (~100 micros!) for a file with... ~15k lines!
    #echo(&"(DEBUG: {target})")

    const maxAttempts = 6
    var attempts = 0

    while attempts < maxAttempts:
        stdout.write(&"\n[Attempt {attempts+1}/6] Enter a word: ")
        var input = readLine(stdin).toLowerAscii()

        if input.len != 5:
            echo("Input must be exactly 5 letters.")
            continue

        if input == target:
            styledEcho(fgGreen, "Correct! The word is: ", target)
            return
        else:
            colorizeword(input, target)
            inc(attempts)

    echo(&"Out of attempts! The correct word was: {target}")

main()
