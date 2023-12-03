discard """

  output: '''
Part A
4361
527144
Part B
467835
81463996
'''
"""

import std/sequtils
from std/strutils import split, isDigit, parseInt
import std/tables

var numIdx = 1

type
  CellKind = enum
    ckEmpty,
    ckNum,
    ckSymbol
  Cell = object
    case k: CellKind
    of ckEmpty:
      empty: bool
    of ckNum:
      num, numIdx: int
    of ckSymbol:
      sym: char
  Row = seq[Cell]
  Schematic = seq[Row]

proc toString(cs: seq[char]): string =
  result = newStringOfCap(len(cs))
  for c in cs:
    result.add(c)

proc parseRow(raw: string): Row =
  result = newSeq[Cell]()
  var i = 0
  while i < len(raw):
    var c = raw[i]
    if c.isDigit():
      var s = newSeq[char]()
      while c.isDigit():
        s.add(c)
        inc(i)
        if i >= len(raw):
          break
        c = raw[i]
      var n = parseInt(toString(s))
      for _ in s:
        result.add(Cell(k: ckNum, num: n, numIdx: numIdx))
      inc(numIdx)
    elif c == '.':
      result.add(Cell(k: ckEmpty, empty: true))
      inc(i)
    else:
      result.add(Cell(k: ckSymbol, sym: c))
      inc(i)

proc parseSchematic(raw: string): Schematic =
  raw.split('\n').map(parseRow)

proc at(s: Schematic, i: int, j: int): Cell =
  if j < 0 or j >= len(s):
    return Cell(k: ckEmpty, empty: true)
  var row = s[j]
  if i < 0 or i >= len(row):
    return Cell(k: ckEmpty, empty: true)
  return row[i]

proc neighbors(s: Schematic, i: int, j: int): Table[int, Cell] =
  result = initTable[int, Cell]()
  for y in j-1 .. j+1:
    for x in i-1 .. i+1:
      var n = s.at(x, y)
      if n.k == ckNum:
        result[n.numIdx] = n

proc part_a(raw: string): int =
  var s = parseSchematic(raw)
  for j, row in s:
    for i, cell in row:
      if cell.k != ckSymbol:
        continue
      for _, n in s.neighbors(i, j):
        result += n.num

proc part_b(raw: string): int =
  var s = parseSchematic(raw)
  for j, row in s:
    for i, cell in row:
      if cell.k != ckSymbol or cell.sym != '*':
        continue
      var ns = s.neighbors(i, j)
      if len(ns) == 2:
        var gr = 1
        for _, n in ns:
          gr *= n.num
        result += gr

let example = readFile("example/03a.txt")
let input = readFile("input/03.txt")

echo "Part A"
echo part_a(example)
echo part_a(input)

echo "Part B"
echo part_b(example)
echo part_b(input)
