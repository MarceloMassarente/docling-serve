# 1. Usa uma imagem oficial do Python baseada em Debian (garantindo o apt-get)
FROM python:3.11-slim-bookworm

# 2. Instala o Tesseract e as dependências de sistema
RUN apt-get update && \
    apt-get install -y tesseract-ocr tesseract-ocr-por tesseract-ocr-eng && \
    rm -rf /var/lib/apt/lists/*

# 3. Instala o Docling-Serve (com as dependências da UI)
RUN pip install --no-cache-dir "docling-serve[ui]"

# 4. Define o ponto de entrada do aplicativo
WORKDIR /app

# 5. PRÉ-CARREGAMENTO DE MODELOS VLM - CORRIGIDO (Usando o CLI)
# O comando 'docling-serve preload' é mais robusto que o import manual.
ENV DOCLING_SERVE_PRELOAD_MODELS="SmolVLM-256M-Instruct"
RUN docling-serve preload $DOCLING_SERVE_PRELOAD_MODELS

# 6. Expõe a porta e inicia o serviço
EXPOSE 5001
CMD ["docling-serve", "run", "--enable-ui"]
