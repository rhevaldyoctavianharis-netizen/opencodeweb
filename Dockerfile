FROM ghcr.io/anomalyco/opencode:latest

# Mengaktifkan auth login dan port dinamis yang diberikan oleh Heroku
CMD opencode web --hostname 0.0.0.0 --port $PORT --auth
