# =============================================================================
# BASE IMAGE
# Menggunakan Node.js versi stabil berbasis Debian
# =============================================================================
FROM node:22-bookworm-slim

# =============================================================================
# INSTALASI DEPENDENSI SISTEM
# git dan ripgrep wajib ada agar OpenCode bisa membaca dan mencari file
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ripgrep \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# INSTALASI OPENCODE CLI
# Memasang OpenCode secara global via npm agar perintah 'opencode' dikenali
# =============================================================================
RUN npm install -g opencode-ai@latest && npm cache clean --force

# =============================================================================
# SETUP USER & WORKSPACE
# Heroku dan praktik keamanan Docker menyarankan untuk tidak menggunakan root
# =============================================================================
RUN mkdir -p /home/opencode/workspace && \
    useradd -m -d /home/opencode opencode && \
    chown -R opencode:opencode /home/opencode

USER opencode
WORKDIR /home/opencode/workspace

# =============================================================================
# MENJALANKAN APLIKASI
# --no-open: Mencegah OpenCode mencoba membuka browser (yang bikin crash)
# --hostname: Menerima koneksi dari luar container
# ${PORT:-4096}: Menggunakan port dinamis Heroku, fallback ke 4096
# =============================================================================
CMD ["sh", "-c", "opencode web --no-open --hostname 0.0.0.0 --port ${PORT:-4096}"]
