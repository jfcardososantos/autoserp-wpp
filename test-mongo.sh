#!/bin/bash

echo "🧪 Testando conexão com MongoDB..."

# Verificar se o container está rodando
if ! docker ps | grep -q "wpp-connect_autoserp-mongo"; then
    echo "❌ Container MongoDB não está rodando"
    echo "Execute: docker-compose up -d autoserp-mongo"
    exit 1
fi

# Testar conexão
echo "Testando ping..."
if docker exec wpp-connect_autoserp-mongo mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    echo "✅ MongoDB está funcionando!"
    echo "✅ Conexão estabelecida com sucesso"
else
    echo "❌ MongoDB não está respondendo"
    echo "Verifique os logs: docker-compose logs autoserp-mongo"
    exit 1
fi

echo "🎉 Teste concluído com sucesso!"
