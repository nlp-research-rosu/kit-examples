def run(a, b, r):
    """Take integer state bindings; return final (a, b, r)."""
    r = a
    a = b
    b = r
    return a, b, r
