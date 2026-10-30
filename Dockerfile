# Base image Node.js Debian yang mendukung multi-arsitektur Heroku
FROM node:22-bookworm-slim

# Instal dependensi sistem wajib (git, ripgrep, curl)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ripgrep curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Instal CLI OpenCode secara global via npm
RUN npm install -g opencode-ai@latest && npm cache clean --force

# Buat direktori kerja dan atur kepemilikan izin file
RUN mkdir -p /home/opencode/workspace && \
    useradd -m -d /home/opencode opencode && \
    chown -R opencode:opencode /home/opencode

USER opencode
WORKDIR /home/opencode/workspace

# Jalankan server tanpa antarmuka (TUI) dan ikat ke port dinamis Heroku
CMD ["sh", "-c", "opencode serve --hostname 0.0.0.0 --port ${PORT:-4096}"]
