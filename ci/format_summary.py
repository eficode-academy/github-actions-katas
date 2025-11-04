import json

try:
    s = json.load(open('summary.json'))
except Exception:
    print('Invalid summary JSON')
    raise

if not isinstance(s, dict) or s.get('count', 0) == 0:
    print('No numbers provided')
else:
    print(f"count={s['count']}, sum={s['sum']}, avg={s['avg']:.2f}, min={s['min']}, max={s['max']}")