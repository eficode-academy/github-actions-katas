#!/usr/bin/env python3
"""
Simple helper used by the composite action exercise.
Reads JSON from stdin (or a file path passed as arg) containing a list of numbers
and prints a small summary: count, sum, average, min, max.
"""
import sys
import json

def summarize(numbers: list[float]) -> dict:
    if not numbers:
        return {"count": 0, "sum": 0, "avg": None, "min": None, "max": None}
    total = sum(numbers)
    return {
        "count": len(numbers),
        "sum": total,
        "avg": total / len(numbers),
        "min": min(numbers),
        "max": max(numbers),
    }


def main():
    data = None
    if len(sys.argv) > 1:
        try:
            with open(sys.argv[1], "r", encoding="utf-8") as f:
                data = json.load(f)
        except Exception as e:
            print(f"Failed to read {sys.argv[1]}: {e}", file=sys.stderr)
            sys.exit(2)
    else:
        try:
            data = json.load(sys.stdin)
        except Exception:
            print("No JSON input provided on stdin and no file given", file=sys.stderr)
            sys.exit(1)

    if not isinstance(data, list):
        print("Expected a JSON array of numbers", file=sys.stderr)
        sys.exit(3)

    try:
        numbers = [float(x) for x in data]
    except Exception:
        print("All items in the array must be numeric", file=sys.stderr)
        sys.exit(4)

    out = summarize(numbers)
    print(json.dumps(out))


if __name__ == "__main__":
    main()
