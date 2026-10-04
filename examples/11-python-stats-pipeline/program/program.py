# Python port of KleverBench problems/imp/stats-pipeline/program.imp.
# Source revision: ecda47f1b820dbd364bbca2f73fcfff4b89bee07.


def run(a, b, n, m, x, t, i, res):
    """Take integer state bindings; return final (a, b, n, m, x, t, i, res)."""
    if a <= b:
        m = a
        x = b
    else:
        m = b
        x = a
    t = x - m
    res = 0
    i = 0
    while i < n:
        res = res + t
        i = i + 1
    res = res + m
    return a, b, n, m, x, t, i, res
