# =============================================================================
# BASE IMAGE
# =============================================================================
FROM node:22-bookworm-slim

# =============================================================================
# INSTALASI DEPENDENSI SISTEM
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ripgrep \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# INSTALASI OPENCODE CLI
# =============================================================================
RUN npm install -g opencode-ai@latest && npm cache clean --force

# =============================================================================
# SETUP USER & WORKSPACE
# =============================================================================
RUN mkdir -p /home/opencode/workspace && \
    useradd -m -d /home/opencode opencode && \
    chown -R opencode:opencode /home/opencode

USER opencode
WORKDIR /home/opencode/workspace

# =============================================================================
# KONFIGURASI PENTING: Paksa UI disajikan secara lokal
# Arahkan ke folder dist UI yang disertakan dalam paket npm.
# Path ini adalah lokasi umum; jika gagal, build akan error dan kita tahu.
# =============================================================================
ENV OPENCODE_WEB_URL=/usr/local/lib/node_modules/opencode-ai/node_modules/opencode-web/dist

# =============================================================================
# MENJALANKAN APLIKASI
# =============================================================================
CMD ["sh", "-c", "opencode web --hostname 0.0.0.0 --port ${PORT:-4096}"]
