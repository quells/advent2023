discard """

  output: '''
Part A
13
27059
Part B
123
123
'''
"""

import std/sequtils
import std/strutils

type
  Card = object
    id: int
    winners: seq[int]
    have: seq[int]

proc score(c: Card): int =
  for h in c.have:
    if c.winners.contains(h):
      inc(result)
  if result > 1:
    result = 1 shl (result - 1)

proc notEmpty(s: string): bool =
  len(s) > 0

proc numbers(raw: string): seq[int] =
  raw.split(' ').filter(notEmpty).map(parseInt)

proc parseCard(line: string): Card =
  var colon = line.split(": ")
  var header = colon[0].split(' ')
  var id = parseInt(header[len(header)-1])
  var pipe = colon[1].split(" | ")
  var winners = numbers(pipe[0])
  var have = numbers(pipe[1])
  Card(id: id, winners: winners, have: have)

proc parseCards(raw: string): seq[Card] =
  raw.split('\n').map(parseCard)

proc part_a(raw: string): int =
  parseCards(raw).map(score).foldl(a + b)

proc part_b(raw: string): int =
  123

let example = readFile("example/04.txt")
let input = readFile("input/04.txt")

echo "Part A"
echo part_a(example)
echo part_a(input)

echo "Part B"
echo part_b(example)
echo part_b(input)
