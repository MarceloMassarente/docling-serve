# 1. Usa a imagem base OTIMIZADA para CPU (melhor para Railway sem GPU)
FROM ghcr.io/docling-project/docling-serve-cpu:latest

# 2. INSTALAÇÃO DO TESSERACT (CORREÇÃO DO PRIMEIRO ERRO)
# Instala o Tesseract e os pacotes de linguagem para Português (por) e Inglês (eng).
RUN apt-get update && \
    apt-get install -y tesseract-ocr tesseract-ocr-por tesseract-ocr-eng && \
    rm -rf /var/lib/apt/lists/*

# 3. PRÉ-CARREGAMENTO DO MODELO VLM (CORREÇÃO DO ERRO 'Repo id must be in the form...')
# O Docling precisa que esse modelo esteja em cache para Classificação/Descrição de Imagem.
# AVISO: Isso adicionará gigabytes ao contêiner e aumentará a exigência de RAM.
ENV DOCLING_SERVE_PRELOAD_MODELS="SmolVLM-256M-Instruct"
RUN python -c "import os; from docling_serve.loader import DoclingServeModelLoader; loader = DoclingServeModelLoader(os.getenv('DOCLING_SERVE_PRELOAD_MODELS')); loader.load_models()"
