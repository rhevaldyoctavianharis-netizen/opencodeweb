FROM ghcr.io/anomalyco/opencode:latest

# Gunakan serve (headless) agar tidak mencoba membuka browser di Heroku
CMD opencode serve --hostname 0.0.0.0 --port $PORT
