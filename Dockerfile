FROM ghcr.io/anomalyco/opencode:latest

# Heroku memberikan port dinamis melalui variabel $PORT
CMD opencode web --hostname 0.0.0.0 --port $PORT
