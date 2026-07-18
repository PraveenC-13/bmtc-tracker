"""
redis_cache.py — writes computed ETA into Redis.
Go reads this same key when the phone asks for ETA.
TTL of 30 seconds means stale ETAs auto-expire automatically.
"""
import json
import redis


def get_client(host="localhost", port=6379):
    return redis.Redis(host=host, port=port, decode_responses=True)


def write_eta(client, direction_id, current_stop, next_stop_eta_sec,
              user_stop_eta_sec, direction_name, ttl_seconds=30):
    payload = {
        "current_stop": current_stop,
        "next_stop_eta_sec": next_stop_eta_sec,
        "user_stop_eta_sec": user_stop_eta_sec,
        "direction": direction_name,
    }
    key = f"eta:{direction_id}"
    client.set(key, json.dumps(payload), ex=ttl_seconds)
    print(f"wrote Redis {key}: {current_stop}, ETA {next_stop_eta_sec:.0f}s")
