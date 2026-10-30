FROM ghcr.io/anomalyco/opencode:latest

# Gunakan exec form dan pastikan binding ke 0.0.0.0 serta port dinamis
CMD ["sh", "-c", "opencode serve --hostname 0.0.0.0 --port $PORT"]
