# 1. Usa uma imagem oficial do Python baseada em Debian, que garante o 'apt-get'
FROM python:3.11-slim-bookworm

# 2. INSTALAÇÃO DO TESSERACT (Sistema Operacional)
RUN apt-get update && \
    apt-get install -y tesseract-ocr tesseract-ocr-por tesseract-ocr-eng && \
    rm -rf /var/lib/apt/lists/*

# 3. INSTALAÇÃO DO DOCLING-SERVE (Python)
# O "docling-serve[ui]" já instala o huggingface_hub
RUN pip install --no-cache-dir "docling-serve[ui]"

# 4. Define o diretório de trabalho
WORKDIR /app

# 5. PRÉ-CARREGAMENTO DE MODELOS VLM (Download Forçado via Hugging Face Hub)
# Este é o comando mais robusto para baixar e cachear o modelo.
ENV DOCLING_VLM_MODEL="HuggingFaceTB/SmolVLM-256M-Instruct"

RUN python -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='${DOCLING_VLM_MODEL}', allow_patterns=['*'], resume_download=True)"

# 6. Configuração e Inicialização
EXPOSE 5001
CMD ["docling-serve", "run", "--enable-ui"]
