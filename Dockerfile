
# =============================================================================
# STAGE 1: BUILDER (Kompilasi binary dari source code)
# =============================================================================
FROM oven/bun:debian AS builder

# Install dependensi sistem yang dibutuhkan saat kompilasi
RUN apt-get update && apt-get install -y --no-install-recommends \
    git python3 make g++ ca-certificates curl ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Clone repository resmi OpenCode (hilangkan flag --depth 1)
WORKDIR /build
RUN git clone https://github.com/anomalyco/opencode.git .

# Install semua dependensi monorepo
RUN bun install

# Panggil build.ts menggunakan bun secara eksplisit
RUN bun ./packages/opencode/script/build.ts --single

# =============================================================================
# STAGE 2: RUNTIME (Image final untuk Heroku)
# =============================================================================
FROM debian:trixie-slim

# Dependensi runtime minimal + ripgrep
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git openssh-client ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Salin binary hasil kompilasi ke direktori eksekusi
COPY --from=builder /build/packages/opencode/dist/*/bin/opencode /usr/local/bin/opencode

# Verifikasi binary dapat dieksekusi
RUN chmod +x /usr/local/bin/opencode && opencode --version

# Buat user non-root untuk keamanan
RUN groupadd -g 1000 opencode && \
    useradd -r -u 1000 -g opencode -s /bin/bash -m opencode

# Environment variable default
ENV OPENCODE_SERVER_USERNAME=opencode
ENV OPENCODE_SERVER_PASSWORD=""

USER opencode
WORKDIR /home/opencode

# Jalankan server headless di port dinamis Heroku
CMD ["sh", "-c", "opencode serve --hostname=0.0.0.0 --port=$PORT"]
