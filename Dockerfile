# 1. Usa uma imagem oficial do Python baseada em Debian, que garante o 'apt-get'
FROM python:3.11-slim-bookworm

# 2. INSTALAÇÃO DO TESSERACT (Sistema Operacional)
# Esta etapa foi a primeira a falhar. Agora funciona.
RUN apt-get update && \
    apt-get install -y tesseract-ocr tesseract-ocr-por tesseract-ocr-eng && \
    rm -rf /var/lib/apt/lists/*

# 3. INSTALAÇÃO DO DOCLING-SERVE (Python)
# Instala o serviço Docling e suas dependências de UI.
RUN pip install --no-cache-dir "docling-serve[ui]"

# 4. Define o diretório de trabalho
WORKDIR /app

# 5. PRÉ-CARREGAMENTO DE MODELOS VLM (Correção da CLI)
# Este é o comando mais provável na CLI para baixar o modelo e colocá-lo no cache.
# Ele corrige o erro "No such command 'preload'".
ENV DOCLING_VLM_MODEL="SmolVLM-256M-Instruct"
RUN docling model download $DOCLING_VLM_MODEL

# 6. Configuração e Inicialização
# Expõe a porta padrão do Docling e inicia o serviço com a UI habilitada.
EXPOSE 5001
CMD ["docling-serve", "run", "--enable-ui"]
