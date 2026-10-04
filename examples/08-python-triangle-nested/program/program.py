# Python port of KleverBench problems/imp/triangle-nested/program.imp.
# Source revision: ecda47f1b820dbd364bbca2f73fcfff4b89bee07.


def run(n, i, j, count):
    """Take integer state bindings; return final (n, i, j, count)."""
    count = 0
    i = n
    while 0 < i:
        j = i
        while 0 < j:
            count = count + 1
            j = j - 1
        i = i - 1
    return n, i, j, count
