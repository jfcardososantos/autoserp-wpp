#!/bin/bash

echo "🔍 Debug: Inicialização de Sessões"
echo "=================================="

# Configurações
SECRET_KEY="JSDHNJDBHFJSD65415415SD1456165GD155164"
SERVER_URL="http://localhost:21465"

echo "📋 Configurações:"
echo "- Secret Key: $SECRET_KEY"
echo "- Server URL: $SERVER_URL"
echo ""

# 1. Verificar se o servidor está rodando
echo "1️⃣  Verificando se o servidor está rodando..."
if curl -s "$SERVER_URL/api-docs" > /dev/null 2>&1; then
    echo "✅ Servidor está respondendo em $SERVER_URL"
else
    echo "❌ Servidor não está respondendo em $SERVER_URL"
    
    # Tentar porta 80
    if curl -s "http://localhost:80/api-docs" > /dev/null 2>&1; then
        echo "⚠️  Servidor rodando na porta 80 (incorreta)"
        SERVER_URL="http://localhost:80"
    else
        echo "❌ Servidor não está respondendo em nenhuma porta conhecida"
        exit 1
    fi
fi

echo ""

# 2. Verificar se há tokens no banco
echo "2️⃣  Verificando tokens no banco..."
if docker ps | grep -q "wpp-connect_autoserp-mongo"; then
    TOKENS_COUNT=$(docker exec wpp-connect_autoserp-mongo mongosh --eval "use tokens; db.tokens.countDocuments()" --quiet 2>/dev/null || echo "0")
    echo "📊 Tokens encontrados: $TOKENS_COUNT"
    
    if [ "$TOKENS_COUNT" -gt 0 ]; then
        echo "📝 Listando tokens:"
        docker exec wpp-connect_autoserp-mongo mongosh --eval "use tokens; db.tokens.find({}, {sessionName: 1, _id: 0})" --quiet 2>/dev/null
    else
        echo "ℹ️  Nenhum token encontrado - isso pode ser o problema!"
    fi
else
    echo "❌ Container MongoDB não está rodando"
fi

echo ""

# 3. Testar endpoint start-all
echo "3️⃣  Testando endpoint start-all..."
echo "URL: $SERVER_URL/api/$SECRET_KEY/start-all"

# Usar curl com mais detalhes
RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}\nTIME:%{time_total}s\nSIZE:%{size_download}" \
    -X POST \
    "$SERVER_URL/api/$SECRET_KEY/start-all" \
    -H "Content-Type: application/json" \
    -H "User-Agent: Debug-Script" \
    -d '{}' \
    --connect-timeout 10 \
    --max-time 30)

# Separar resposta e metadados
HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
TIME=$(echo "$RESPONSE" | grep "TIME:" | cut -d: -f2)
SIZE=$(echo "$RESPONSE" | grep "SIZE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:" | grep -v "TIME:" | grep -v "SIZE:")

echo "📊 Resposta:"
echo "- HTTP Code: $HTTP_CODE"
echo "- Tempo: ${TIME}s"
echo "- Tamanho: ${SIZE} bytes"
echo "- Body: $BODY"

echo ""

# 4. Análise do resultado
echo "4️⃣  Análise do resultado..."
if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Endpoint start-all funcionando perfeitamente!"
elif [ "$HTTP_CODE" = "400" ]; then
    echo "❌ Erro 400 - Bad Request"
    echo "   Possível problema: Secret key incorreta ou parâmetros inválidos"
elif [ "$HTTP_CODE" = "500" ]; then
    echo "❌ Erro 500 - Internal Server Error"
    echo "   Possível problema: Erro no servidor ou banco de dados"
elif [ "$HTTP_CODE" = "000" ]; then
    echo "❌ Erro de conexão"
    echo "   Possível problema: Servidor não está respondendo ou timeout"
else
    echo "❌ Erro desconhecido: $HTTP_CODE"
fi

echo ""

# 5. Recomendações
echo "5️⃣  Recomendações:"
if [ "$TOKENS_COUNT" = "0" ]; then
    echo "🔧 Crie uma sessão primeiro:"
    echo "   curl -X POST '$SERVER_URL/api/$SECRET_KEY/create' \\"
    echo "     -H 'Content-Type: application/json' \\"
    echo "     -d '{\"sessionName\": \"test-session\"}'"
fi

if [ "$SERVER_URL" != "http://localhost:21465" ]; then
    echo "🔧 Corrija a porta do servidor:"
    echo "   docker-compose down && docker-compose up --build"
fi

echo ""
echo "�� Debug concluído!"
