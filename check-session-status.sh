#!/bin/bash

echo "🔍 Verificando status das sessões..."
echo "===================================="

# Configurações
SECRET_KEY="JSDHNJDBHFJSD65415415SD1456165GD155164"
SERVER_URL="http://localhost:21465"

echo "📋 Configurações:"
echo "- Secret Key: $SECRET_KEY"
echo "- Server URL: $SERVER_URL"
echo ""

# 1. Verificar se o servidor está respondendo
echo "1️⃣  Verificando servidor..."
if curl -s "$SERVER_URL/api-docs" > /dev/null 2>&1; then
    echo "✅ Servidor funcionando"
else
    echo "❌ Servidor não está respondendo"
    exit 1
fi

# 2. Verificar sessões disponíveis
echo ""
echo "2️⃣  Verificando sessões disponíveis..."
SESSIONS_RESPONSE=$(curl -s "$SERVER_URL/api/$SECRET_KEY/sessions")
echo "Resposta: $SESSIONS_RESPONSE"

# 3. Verificar status de uma sessão específica (se existir)
echo ""
echo "3️⃣  Verificando status da sessão 'alfst'..."
if echo "$SESSIONS_RESPONSE" | grep -q "alfst"; then
    echo "✅ Sessão 'alfst' encontrada"
    
    # Verificar status
    STATUS_RESPONSE=$(curl -s "$SERVER_URL/api/$SECRET_KEY/alfst/status")
    echo "Status da sessão: $STATUS_RESPONSE"
    
    # Verificar se está conectada
    if echo "$STATUS_RESPONSE" | grep -q "connected"; then
        echo "✅ Sessão conectada e pronta para uso"
    else
        echo "⚠️  Sessão não está conectada"
        echo "   - Pode estar aguardando QR Code"
        echo "   - Ou pode ter falhado na inicialização"
    fi
else
    echo "❌ Sessão 'alfst' não encontrada"
fi

# 4. Testar envio de mensagem (se a sessão estiver pronta)
echo ""
echo "4️⃣  Testando envio de mensagem..."
if echo "$STATUS_RESPONSE" | grep -q "connected"; then
    echo "Testando envio para número de teste..."
    TEST_RESPONSE=$(curl -s -X POST \
        "$SERVER_URL/api/$SECRET_KEY/alfst/send-message" \
        -H "Content-Type: application/json" \
        -d '{"phone": "5521999999999", "message": "Teste de conexão"}')
    
    if echo "$TEST_RESPONSE" | grep -q "error"; then
        echo "❌ Erro ao enviar mensagem: $TEST_RESPONSE"
    else
        echo "✅ Mensagem enviada com sucesso: $TEST_RESPONSE"
    fi
else
    echo "ℹ️  Sessão não está pronta para teste"
fi

echo ""
echo "🎉 Verificação concluída!"
echo ""
echo "📝 Próximos passos:"
echo "1. Se a sessão não estiver conectada, escaneie o QR Code"
echo "2. Se houver erro, verifique os logs: docker-compose logs -f wppconnect"
echo "3. Para criar nova sessão: curl -X POST '$SERVER_URL/api/$SECRET_KEY/create'"
