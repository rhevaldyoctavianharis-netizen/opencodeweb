# =============================================================================
# STAGE 1: BUILDER (Membangun OpenCode dari Source GitHub)
# =============================================================================
FROM oven/bun:debian AS builder

# Install dependensi sistem untuk proses build
RUN apt-get update && apt-get install -y --no-install-recommends \
    git python3 make g++ ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# Clone repositori OpenCode resmi
WORKDIR /build
RUN git clone --depth 1 https://github.com/anomalyco/opencode.git .

# Install dependensi menggunakan Bun dan build binary-nya
# Perintah ini menghasilkan binary opencode yang siap jalan
RUN bun install --frozen-lockfile
RUN bun run --filter opencode build

# =============================================================================
# STAGE 2: RUNTIME (Image Final untuk Heroku)
# =============================================================================
FROM debian:trixie-slim

# Install dependensi runtime minimal yang dibutuhkan OpenCode
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Salin binary OpenCode hasil build dari stage sebelumnya
COPY --from=builder /build/packages/opencode/dist/*/bin/opencode /usr/local/bin/opencode

# Pastikan binary dapat dieksekusi dan verifikasi instalasi
RUN chmod +x /usr/local/bin/opencode && opencode --version

# Buat user non-root untuk keamanan
RUN groupadd -g 1000 opencode || true && \
    useradd -r -u 1000 -g opencode -s /bin/bash -m opencode || true

# Set environment variable default (bisa ditimpa oleh Heroku Config Vars)
ENV OPENCODE_SERVER_USERNAME=opencode
ENV OPENCODE_SERVER_PASSWORD=""

# Pindah ke user non-root
USER opencode
WORKDIR /home/opencode

# Jalankan server headless (serve) di port dinamis Heroku
CMD ["sh", "-c", "opencode serve --hostname=0.0.0.0 --port=$PORT"]
