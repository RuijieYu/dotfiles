#!/usr/bin/env python3
from os import environ as e

RANKS = ["B", "KiB", "MiB", "GiB", "TiB", "PiB",]

def rev_ranks():
    return list(reversed(list(enumerate(RANKS))))

def _rank(s: str, /) -> int:
    return list(filter(lambda r: s.endswith(r[1]), rev_ranks()))[0][0]

def num(s: str, /) -> float:
    r = _rank(s)
    return float(s[:(-3 if r else -1)]) * (2 ** (10 * r))

def level(total: float, perc: float, flat: str):
    return min(total * perc / 100, num(flat))

def show_flat(s, /) -> str:
    def inner(s, it) -> str:
        r: str = next(it)
        if 0 <= s < 1024: return f'{float(s):3.2f}{r}'
        return inner(s / 1024, it)
    return inner(s, iter(RANKS))

def get_color(free, warn, crit):
    return (
        e.get('CRIT_COLOR', '#ffff32') if free <= crit else
        e.get('WARN_COLOR', '#ff3232') if free <= warn else
        '#ffffff'
    )

def display(total: str, usage: str, reserve: str = '512MiB'):
    total, usage, reserve = (num(s) for s in (total, usage, reserve))
    subtotal = total - reserve
    free = subtotal - usage
    warn, crit = [
        level(
            subtotal,
            float(e.get(f"{L}_PERC")) or 100.,
            e.get(f"{L}_FLAT") or f"inf{RANKS[-1]}"
        ) for L in ("WARN", "CRIT")]

    color = get_color(free, warn, crit)
    # free = f'MD {show_flat(free)} @ {free / subtotal * 100:2.03}%'
    free = f'MD {show_flat(free)} @ {free / subtotal:2.2%}'
    print(free, free, color, sep='\n')

# total, usage = "8.00GiB", "6.32GiB"
if __name__ == '__main__':
    display(total=input(), usage=input())
