# Python port of KleverBench problems/imp/sum/program.imp.
# Source revision: ecda47f1b820dbd364bbca2f73fcfff4b89bee07.


def run(n, sum):
    """Take integer state bindings; return final (n, sum)."""
    while not (n <= 0):
        sum = sum + n
        n = n + -1
    return n, sum
