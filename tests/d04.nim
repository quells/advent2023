discard """

  output: '''
Part A
13
27059
Part B
30
123
'''
"""

import std/sequtils
import std/strutils
import std/tables

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
  var cards = parseCards(raw)
  var copies = newCountTable[int]()
  for c in cards:
    copies[c.id] = copies[c.id] + 1
    var s = c.score()
    if cards.len() <= c.id + s:
      s = cards.len() - c.id - 2
    echo c.id, " ", s
    echo copies[c.id]
    for i in 1 .. s:
      var idx = c.id + i
      copies[idx] = copies[idx] + copies[c.id]
  for c in copies.values():
    result += c

let example = readFile("example/04.txt")
let input = readFile("input/04.txt")

echo "Part A"
echo part_a(example)
echo part_a(input)

echo "Part B"
echo part_b(example)
echo part_b(input)
