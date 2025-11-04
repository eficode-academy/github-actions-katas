#!/usr/bin/env python3
"""
Format and display a summary from a JSON file.
Takes a JSON file path as a command-line argument.
"""
import json
import sys
from typing import Any


def load_json_file(file_path: str) -> dict[str, Any]:
    """Load and parse a JSON file with proper error handling.
    
    Args:
        file_path: Path to the JSON file to load
        
    Returns:
        The parsed JSON data as a dictionary
        
    Raises:
        SystemExit: On file or JSON parsing errors
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found", file=sys.stderr)
        sys.exit(2)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in '{file_path}': {e}", file=sys.stderr)
        sys.exit(2)
    except OSError as e:
        print(f"Error: Failed to read '{file_path}': {e}", file=sys.stderr)
        sys.exit(2)


def main() -> None:
    """Load a number summary in json format and output a human readable string instead
    """
    if len(sys.argv) != 2:
        print("Usage: python format_summary.py <summaryfile>", file=sys.stderr)
        sys.exit(1)
    
    json_file = sys.argv[1]
    summary = load_json_file(json_file)

    if not isinstance(summary, dict) or summary.get('count', 0) == 0:
        print('No numbers provided')
    else:
        print(f"count={summary['count']}, sum={summary['sum']}, avg={summary['avg']:.2f}, min={summary['min']}, max={summary['max']}")


if __name__ == "__main__":
    main()