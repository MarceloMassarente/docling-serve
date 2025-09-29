# 1. Usa a imagem base padrão (que geralmente é Debian/Ubuntu e tem apt-get)
# NOTA: O Railway vai usar esta imagem base para construir a sua versão customizada.
FROM quay.io/docling-project/docling-serve:latest

# 2. Instala o Tesseract e as pacotes de linguagem
RUN apt-get update && \
    apt-get install -y tesseract-ocr tesseract-ocr-por tesseract-ocr-eng && \
    rm -rf /var/lib/apt/lists/*

# 3. Pré-carregamento do Modelo VLM (mantenha, se quiser a classificação de imagens)
ENV DOCLING_SERVE_PRELOAD_MODELS="SmolVLM-256M-Instruct"
RUN python -c "import os; from docling_serve.loader import DoclingServeModelLoader; loader = DoclingServeModelLoader(os.getenv('DOCLING_SERVE_PRELOAD_MODELS')); loader.load_models()"
