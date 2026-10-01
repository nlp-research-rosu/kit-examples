def run(a, res):
    """Take integer state bindings; return final (a, res)."""
    if a < 0:
        res = 0 - a
    else:
        res = a
    return a, res
