#!/usr/bin/env python3
"""Convert verified phrase-level SRT to ASS without estimating new cue timings."""
import argparse
import re
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


def centiseconds(ts):
    h, m, seconds = ts.replace(',', '.').split(':')
    value = (int(h) * 3600 + int(m) * 60 + Decimal(seconds)) * 100
    return int(value.quantize(Decimal(1), rounding=ROUND_HALF_UP))


def ass_time(value):
    hours, rest = divmod(value, 360000)
    minutes, rest = divmod(rest, 6000)
    seconds, fraction = divmod(rest, 100)
    return f'{hours}:{minutes:02d}:{seconds:02d}.{fraction:02d}'


def escape(text):
    # Prevent source text from introducing ASS tags or control sequences.
    return text.replace('\\', '＼').replace('{', '(').replace('}', ')')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--font', default='Alef')
    parser.add_argument('--font-size', type=int, default=78)
    parser.add_argument('--rechunk-words', type=int, default=0,
                        help='Optional provisional chunks; estimates timing, not word alignment')
    args = parser.parse_args()
    if args.rechunk_words < 0 or args.font_size <= 0:
        parser.error('rechunk-words must be nonnegative and font-size must be positive')
    if any(c in args.font for c in ',\n\r'):
        parser.error('font name cannot contain commas or line breaks')
    if args.output.exists():
        parser.error('output exists; choose a new filename')
    raw = args.input.read_text(encoding='utf-8-sig').strip()
    events = []
    previous_end = 0
    for number, block in enumerate(re.split(r'\n\s*\n', raw), 1):
        lines = [line.strip() for line in block.splitlines() if line.strip()]
        if lines and re.fullmatch(r'\d+', lines[0]):
            lines = lines[1:]
        if len(lines) < 2 or '-->' not in lines[0]:
            parser.error(f'malformed SRT block {number}')
        try:
            start, end = [centiseconds(x.strip()) for x in lines[0].split('-->')]
        except (ValueError, ArithmeticError):
            parser.error(f'invalid time in block {number}')
        if start < previous_end or end <= start:
            parser.error(f'overlap, out-of-order or nonpositive cue in block {number}')
        previous_end = end
        if args.rechunk_words:
            words = ' '.join(lines[1:]).split()
            chunks = [' '.join(words[i:i + args.rechunk_words])
                      for i in range(0, len(words), args.rechunk_words)]
            weights = [len(chunk) for chunk in chunks]
            total = sum(weights)
            cursor, used = start, 0
            for chunk, weight in zip(chunks, weights):
                used += weight
                finish = start + round((end - start) * used / total)
                if finish <= cursor:
                    parser.error(f'block {number} is too short to rechunk')
                events.append((cursor, finish, escape(chunk)))
                cursor = finish
        else:
            events.append((start, end, r'\N'.join(escape(x) for x in lines[1:])))

    header = f'''[Script Info]
ScriptType: v4.00+
PlayResX: 1080
PlayResY: 1920
WrapStyle: 0
ScaledBorderAndShadow: yes

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Viral,{args.font},{args.font_size},&H00FFFFFF,&H0000D7FF,&H00101010,&H80000000,-1,0,0,0,100,100,0,0,1,4,2,2,100,140,245,1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
'''
    pop = r'{\fscx96\fscy96\t(0,67,\fscx100\fscy100)}'
    body = '\n'.join(f'Dialogue: 0,{ass_time(a)},{ass_time(b)},Viral,,0,0,0,,{pop}{text}'
                     for a, b, text in events)
    with args.output.open('x', encoding='utf-8') as output:
        output.write(header + body + '\n')


if __name__ == '__main__':
    main()
