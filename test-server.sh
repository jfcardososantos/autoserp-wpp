#!/bin/bash

echo "🧪 Testando se o servidor está respondendo..."

# Aguardar um pouco para o servidor inicializar
echo "Aguardando servidor inicializar..."
sleep 5

# Testar se o servidor está respondendo
echo "Testando endpoint /api-docs..."
if curl -s http://localhost:21465/api-docs > /dev/null 2>&1; then
    echo "✅ Servidor está respondendo!"
    echo "🌐 Acesse: http://localhost:21465/api-docs"
else
    echo "❌ Servidor não está respondendo na porta 21465"
    echo "Verifique os logs: docker-compose logs -f wppconnect"
    exit 1
fi

echo "🎉 Teste concluído com sucesso!"
