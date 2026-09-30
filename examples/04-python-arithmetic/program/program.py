def run(a, b, res):
    """Take integer state bindings; return final (a, b, res)."""
    res = a * b + a - b
    return a, b, res
