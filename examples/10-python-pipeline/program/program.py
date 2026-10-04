# Python port of KleverBench problems/imp/pipeline/program.imp.
# Source revision: ecda47f1b820dbd364bbca2f73fcfff4b89bee07.


def run(a, b, n, t, i, res):
    """Take integer state bindings; return final (a, b, n, t, i, res)."""
    t = a * b
    if t < 0:
        t = 0 - t
    else:
        pass
    res = 0
    i = 0
    while i < n:
        res = res + t
        i = i + 1
    res = res + a
    return a, b, n, t, i, res
