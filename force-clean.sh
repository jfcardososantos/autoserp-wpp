#!/bin/bash

echo "🧹 FORÇANDO LIMPEZA COMPLETA..."
echo "================================"

echo "1️⃣  Parando TODOS os containers..."
docker-compose down
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

echo "2️⃣  Removendo diretórios problemáticos..."
rm -rf ./userDataDir
rm -rf ./wppconnect_tokens
rm -rf ./node_modules
rm -rf ./dist

echo "3️⃣  Limpando cache do Docker..."
docker system prune -f
docker volume prune -f

echo "4️⃣  Reinstalando dependências..."
npm install

echo "5️⃣  Reconstruindo containers..."
docker-compose up --build -d

echo "6️⃣  Aguardando inicialização completa..."
sleep 20

echo "7️⃣  Verificando status..."
if curl -s http://localhost:21465/api-docs > /dev/null 2>&1; then
    echo "✅ Servidor funcionando na porta 21465!"
    echo "🌐 Acesse: http://localhost:21465/api-docs"
else
    echo "❌ Servidor não está respondendo"
    echo "Verifique os logs: docker-compose logs -f wppconnect"
fi

echo ""
echo "🎉 Limpeza forçada concluída!"
echo "⚠️  ATENÇÃO: Todos os dados foram perdidos!"
echo "   - Tokens de sessão"
echo "   - Perfis do navegador"
echo "   - Cache e dados temporários"
