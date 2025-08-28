#!/bin/bash

echo "🚀 Iniciando WPPConnect Server..."

# Iniciar MongoDB
echo "Iniciando MongoDB..."
docker-compose up -d autoserp-mongo

# Aguardar um pouco para o MongoDB inicializar
echo "Aguardando MongoDB inicializar..."
sleep 10

# Iniciar o servidor
echo "Iniciando servidor..."
docker-compose up -d wppconnect

echo "✅ Servidor iniciado!"
echo "📊 Logs disponíveis em: docker-compose logs -f wppconnect"
echo "🌐 Acesse: http://localhost:21465/api-docs"
