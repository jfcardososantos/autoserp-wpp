#!/bin/bash

echo "🔍 Verificando porta do servidor..."

# Verificar se o servidor está rodando na porta 21465
echo "1. Testando porta 21465 (configurada)..."
if curl -s http://localhost:21465/api-docs > /dev/null 2>&1; then
    echo "✅ Servidor rodando na porta 21465"
    PORT=21465
else
    echo "❌ Servidor não está na porta 21465"
    
    # Verificar se está na porta 80
    echo "2. Testando porta 80..."
    if curl -s http://localhost:80/api-docs > /dev/null 2>&1; then
        echo "⚠️  Servidor rodando na porta 80 (incorreta)"
        PORT=80
    else
        echo "❌ Servidor não está respondendo em nenhuma porta conhecida"
        exit 1
    fi
fi

echo "3. Testando endpoint start-all na porta $PORT..."
RESPONSE=$(curl -s -w "%{http_code}" -X POST \
    "http://localhost:$PORT/api/JSDHNJDBHFJSD65415415SD1456165GD155164/start-all" \
    -H "Content-Type: application/json")

HTTP_CODE="${RESPONSE: -3}"
BODY="${RESPONSE%???}"

echo "HTTP Code: $HTTP_CODE"
echo "Response: $BODY"

if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Endpoint start-all funcionando!"
else
    echo "❌ Erro no endpoint start-all"
fi

echo ""
echo "📊 Resumo:"
echo "- Porta configurada: 21465"
echo "- Porta atual: $PORT"
if [ "$PORT" != "21465" ]; then
    echo "⚠️  ATENÇÃO: Servidor rodando na porta incorreta!"
    echo "   Execute: docker-compose down && docker-compose up --build"
fi

echo "🎉 Verificação concluída!"
