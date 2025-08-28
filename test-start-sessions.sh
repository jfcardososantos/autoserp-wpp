#!/bin/bash

echo "🧪 Testando inicialização de sessões..."

# Configurações
SECRET_KEY="JSDHNJDBHFJSD65415415SD1456165GD155164"
SERVER_URL="http://localhost:21465"

echo "Secret Key: $SECRET_KEY"
echo "Server URL: $SERVER_URL"

# Testar se o servidor está respondendo
echo "1. Testando se o servidor está respondendo..."
if curl -s "$SERVER_URL/api-docs" > /dev/null 2>&1; then
    echo "✅ Servidor está respondendo"
else
    echo "❌ Servidor não está respondendo"
    exit 1
fi

# Testar endpoint start-all
echo "2. Testando endpoint start-all..."
RESPONSE=$(curl -s -w "%{http_code}" -X POST \
    "$SERVER_URL/api/$SECRET_KEY/start-all" \
    -H "Content-Type: application/json")

HTTP_CODE="${RESPONSE: -3}"
BODY="${RESPONSE%???}"

echo "HTTP Code: $HTTP_CODE"
echo "Response: $BODY"

if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Endpoint start-all funcionando!"
else
    echo "❌ Erro no endpoint start-all"
    echo "Verifique os logs do servidor"
fi

echo "�� Teste concluído!"
