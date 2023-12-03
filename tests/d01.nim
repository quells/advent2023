discard """

  output: '''
Part A
142
54940
Part B
281
54208
'''
"""

import std/sequtils
from std/strutils import parseInt, split

proc findDigits(raw: string): seq[seq[int]] =
    result = newSeq[seq[int]]()
    for line in raw.split('\n'):
        var ds = newSeq[int]()
        for c in line:
            if '0' <= c and c <= '9':
                ds.add(parseInt($c))
        result.add(ds)

proc findSneakyDigits(raw: string): seq[seq[int]] =
    result = newSeq[seq[int]]()
    for line in raw.split('\n'):
        var n = len(line)
        var ds = newSeq[int]()
        for i, c in line:
            if '0' <= c and c <= '9':
                ds.add(parseInt($c))
            elif c == 'o' and n-i > 2:
                if line[i .. i+2] == "one":
                    ds.add(1)
            elif c == 't':
                if n-i > 2:
                    if line[i .. i+2] == "two":
                        ds.add(2)
                if n-i > 4:
                    if line[i .. i+4] == "three":
                        ds.add(3)
            elif c == 'f':
                if n-i > 3:
                    var f = line[i .. i+3]
                    if f == "four":
                        ds.add(4)
                    elif f == "five":
                        ds.add(5)
            elif c == 's':
                if n-i > 2:
                    if line[i .. i+2] == "six":
                        ds.add(6)
                if n-i > 4:
                    if line[i .. i+4] == "seven":
                        ds.add(7)
            elif c == 'e':
                if n-i > 4:
                    if line[i .. i+4] == "eight":
                        ds.add(8)
            elif c == 'n':
                if n-i > 3:
                    if line[i .. i+3] == "nine":
                        ds.add(9)
        result.add(ds)

proc combineDigits(vs: seq[int]): int =
    result = vs[0] * 10 + vs[len(vs)-1]

proc part_a(raw: string): int =
    findDigits(raw).map(combineDigits).foldl(a + b)

proc part_b(raw: string): int =
    findSneakyDigits(raw).map(combineDigits).foldl(a + b)

let input = readFile("input/01.txt")

echo "Part A"
echo part_a(readFile("example/01a.txt"))
echo part_a(input)

echo "Part B"
echo part_b(readFile("example/01b.txt"))
echo part_b(input)
