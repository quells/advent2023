discard """

  output: '''
142
54940
'''
"""

import std/sequtils
from std/strutils import parseInt, split

let example_a = readFile("example/01a.txt")
let input = readFile("input/01.txt")

proc findDigits(raw: string): seq[seq[int]] =
    result = newSeq[seq[int]]()
    for line in raw.split('\n'):
        var ds = newSeq[int]()
        for c in line:
            if '0' <= c and c <= '9':
                ds.add(parseInt($c))
        result.add(ds)

proc combineDigits(vs: seq[int]): int =
    result = vs[0] * 10 + vs[len(vs)-1]

proc part_a(raw: string): int =
    result = 0
    for d in findDigits(raw).map(combineDigits):
        result += d

echo part_a(example_a)
echo part_a(input)
