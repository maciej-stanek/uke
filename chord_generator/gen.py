#!/usr/bin/env python3

semitones = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]

chords = {
    ""    : [0, 4, 7],     # Major triad
    "6"   : [0, 4, 7, 9],  # Major sixth chord
    "7"   : [0, 4, 7, 10], # Dominant seventh chord
    "M7"  : [0, 4, 7, 11], # Major seventh chord
    "+"   : [0, 4, 8],     # Augumented triad
    "+7"  : [0, 4, 8, 10], # Augumented seventh chord
    "m"   : [0, 3, 7],     # Minor triad
    "m6"  : [0, 3, 7, 9],  # Minor sixth chord
    "m7"  : [0, 3, 7, 10], # Minor seventh chord
    "mM7" : [0, 3, 7, 11], # Minor-major seventh chord
    "o"   : [0, 3, 6],     # Diminished triad
    "o7"  : [0, 3, 6, 9],  # Diminished seventh chord
    "/o"  : [0, 3, 6, 10], # Half-diminished seventh chord
}

strings = [
    ("A", 4),
    ("E", 4),
    ("C", 4),
    ("G", 4),
]

def note_to_absolute(note):
    return note[1] * 12 + semitones.index(note[0])

for string, octave in strings:
    print(string, note_to_absolute((string, octave)))

