# Python port of KleverBench problems/imp/count-even/program.imp.
# Source revision: ecda47f1b820dbd364bbca2f73fcfff4b89bee07.


def run(n, i, count):
    """Take integer state bindings; return final (n, i, count)."""
    count = 0
    i = 0
    while i < n:
        if i % 2 == 0:
            count = count + 1
        else:
            pass
        i = i + 1
    return n, i, count
