# Menggunakan image resmi OpenCode yang sudah dikompilasi
FROM ghcr.io/anomalyco/opencode:latest

# Menjalankan server headless (tanpa membuka browser)
# Port dinamis dari Heroku ($PORT) akan digunakan secara otomatis
CMD ["sh", "-c", "opencode serve --hostname 0.0.0.0 --port $PORT"]
