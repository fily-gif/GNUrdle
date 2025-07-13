import std/random
import std/strformat
import std/strutils
import std/terminal

randomize()

const fn = "words/unix.txt"
const maxAttempts = 6

type
  Status = enum Green, Yellow, Gray
  WordStatus = array[5, Status]

proc loadWords(filename: string): seq[string] =
  try:
    let file = readFile(filename)
    let lines = file.splitLines()
    return lines
  except IOError:
    quit(&"Failed to load word list from '{filename}'")

proc statusToEmoji(s: Status): string =
  case s
  of Green: "🟩"
  of Yellow: "🟨"
  of Gray: "⬛"

proc getStatuses(word: string, target: string): WordStatus =
  var statuses: WordStatus
  var used: array[5, bool]

  for i in 0 ..< 5:
    if word[i] == target[i]:
      statuses[i] = Green
      used[i] = true
    else:
      statuses[i] = Gray

  for i in 0 ..< 5:
    if statuses[i] == Gray:
      for j in 0 ..< 5:
        if not used[j] and word[i] == target[j]:
          statuses[i] = Yellow
          used[j] = true
          break

  return statuses

proc showColored(word: string, statuses: WordStatus) =
  for i in 0 ..< 5:
    case statuses[i]
    of Green: stdout.styledWrite(fgBlack, bgGreen, $word[i])
    of Yellow: stdout.styledWrite(fgBlack, bgYellow, $word[i])
    of Gray: stdout.styledWrite(fgBlack, bgWhite, $word[i])
  echo()

proc printSummary(statuses: seq[WordStatus], won: bool, attempts: int, wordint: int) =
  echo()
  if won:
    echo(&"GNUrdle #{wordint} {attempts}/{maxAttempts}")
  else:
    echo(&"GNUrdle #{wordint} X/6")

  for stat in statuses:
    for s in stat:
      stdout.write(statusToEmoji(s))
    echo()

proc playGame(wordList: seq[string]) =
  echo("Guess the 5-letter UNIX command!")

  let randword = rand(wordList.len)
  let target = wordList[randword]

  var attempts = 0
  var statusLog: seq[WordStatus]
  var won = false

  while attempts < maxAttempts:
    stdout.write(&"\n[{attempts + 1}/{maxAttempts}] > ")
    var input = readLine(stdin).toLowerAscii()

    if input.len != 5:
      echo("Input must be exactly 5 letters.")
      continue

    if input notin wordList:
      echo("That word is not in the word list!")
      continue

    let status = getStatuses(input, target)
    statusLog.add status
    showColored(input, status)

    if input == target:
      styledEcho(fgGreen, "\nCorrect! The word is: ", target)
      won = true
      break

    inc(attempts)

  if not won:
    styledEcho(fgRed, "\nOut of attempts! The correct word was: ", target)

  printSummary(statusLog, won, attempts + (if won: 0 else: 1), randword)

proc playAgain(): bool =
  stdout.write("\nPlay again? (y/n): ")
  let ans = readLine(stdin).strip().toLowerAscii()
  return ans == "y" or ans == "yes"

when isMainModule:
  let words = loadWords(fn)
  if words.len == 0:
    quit("Word list is empty or improperly formatted.")

  while true:
    playGame(words)
    if not playAgain():
      break
