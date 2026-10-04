# Python port of KleverBench problems/imp/nested-with-branch/program.imp.
# Source revision: ecda47f1b820dbd364bbca2f73fcfff4b89bee07.


def run(a, b, i, j, res):
    """Take integer state bindings; return final (a, b, i, j, res)."""
    res = 0
    i = a
    while 0 < i:
        if i <= b:
            j = i
            while 0 < j:
                res = res + 1
                j = j - 1
        else:
            pass
        i = i - 1
    return a, b, i, j, res
