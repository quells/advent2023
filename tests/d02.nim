discard """

  output: '''
Part A
8
2278
Part B
2286
67953
'''
"""

import std/sequtils
from std/strutils import parseInt, split

type Bag = object
    r, g, b: int

type Game = object
    idx: int
    samples: seq[Bag]

proc parseSample(raw: string): Bag =
    result = Bag()
    for cc in raw.split(", "):
        var ccs = cc.split(' ')
        var count = parseInt(ccs[0])
        var color = ccs[1]
        if color == "red":
            result.r = count
        elif color == "green":
            result.g = count
        elif color == "blue":
            result.b = count

proc parseGame(line: string): Game =
    var cut = line.split(": ")
    var idx = parseInt(cut[0].split(' ')[1])
    result = Game(idx: idx, samples: newSeq[Bag]())
    for sample in cut[1].split("; "):
        result.samples.add(parseSample(sample))

proc parseGames(raw: string): seq[Game] =
    result = newSeq[Game]()
    for line in raw.split('\n'):
        result.add(parseGame(line))

proc max(g: Game): Bag =
    result = Bag()
    for s in g.samples:
        result.r = max(result.r, s.r)
        result.g = max(result.g, s.g)
        result.b = max(result.b, s.b)

proc possible(g: Game): bool =
    var m = g.max()
    m.r <= 12 and m.g <= 13 and m.b <= 14

proc part_a(raw: string): int =
    parseGames(raw).filter(possible).foldl(a + b.idx, 0)

proc power(b: Bag): int =
    b.r * b.g * b.b

proc part_b(raw: string): int =
    parseGames(raw).map(max).map(power).foldl(a + b)

let example = readFile("example/02a.txt")
let input = readFile("input/02.txt")

echo "Part A"
echo part_a(example)
echo part_a(input)

echo "Part B"
echo part_b(example)
echo part_b(input)
