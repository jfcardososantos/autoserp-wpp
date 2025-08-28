#!/bin/bash

echo "🔍 Verificando tokens no banco de dados..."

# Verificar se o MongoDB está rodando
if ! docker ps | grep -q "wpp-connect_autoserp-mongo"; then
    echo "❌ Container MongoDB não está rodando"
    echo "Execute: docker-compose up -d autoserp-mongo"
    exit 1
fi

echo "1. Testando conexão com MongoDB..."
if docker exec wpp-connect_autoserp-mongo mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    echo "✅ MongoDB está funcionando"
else
    echo "❌ MongoDB não está respondendo"
    exit 1
fi

echo "2. Verificando banco 'tokens'..."
if docker exec wpp-connect_autoserp-mongo mongosh --eval "use tokens; db.stats()" > /dev/null 2>&1; then
    echo "✅ Banco 'tokens' existe"
else
    echo "❌ Banco 'tokens' não existe"
    echo "Criando banco..."
    docker exec wpp-connect_autoserp-mongo mongosh --eval "use tokens; db.createCollection('tokens')"
fi

echo "3. Verificando coleção 'tokens'..."
TOKENS_COUNT=$(docker exec wpp-connect_autoserp-mongo mongosh --eval "use tokens; db.tokens.countDocuments()" --quiet)
echo "📊 Tokens encontrados: $TOKENS_COUNT"

if [ "$TOKENS_COUNT" -gt 0 ]; then
    echo "4. Listando tokens:"
    docker exec wpp-connect_autoserp-mongo mongosh --eval "use tokens; db.tokens.find({}, {sessionName: 1, _id: 0})" --quiet
else
    echo "ℹ️  Nenhum token encontrado. Isso é normal se você ainda não criou sessões."
fi

echo "🎉 Verificação concluída!"
