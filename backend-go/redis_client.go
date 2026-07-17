package main

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/redis/go-redis/v9"
)

type RedisClient struct {
	client *redis.Client
}

func NewRedisClient(addr string) *RedisClient {
	return &RedisClient{
		client: redis.NewClient(&redis.Options{Addr: addr}),
	}
}

// GetETA reads the cached ETA written by the Python service.
// This is the entire read path — Go never computes ETA itself.
func (r *RedisClient) GetETA(ctx context.Context, directionID int) (*ETAResponse, error) {
	key := fmt.Sprintf("eta:%d", directionID)
	val, err := r.client.Get(ctx, key).Result()
	if err != nil {
		return nil, err
	}
	var eta ETAResponse
	if err := json.Unmarshal([]byte(val), &eta); err != nil {
		return nil, err
	}
	return &eta, nil
}
