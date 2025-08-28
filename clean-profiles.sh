#!/bin/bash

echo "🧹 Limpando perfis conflitantes do Chromium..."
echo "=============================================="

# Verificar se o container está rodando
if docker ps | grep -q "wpp-server"; then
    echo "⚠️  Container rodando. Parando primeiro..."
    docker-compose down
fi

echo "1️⃣  Removendo diretórios de perfil antigos..."
if [ -d "./userDataDir" ]; then
    echo "Removendo ./userDataDir..."
    rm -rf ./userDataDir
    echo "✅ Diretório removido"
else
    echo "ℹ️  Diretório ./userDataDir não existe"
fi

echo "2️⃣  Criando diretório limpo..."
mkdir -p ./userDataDir
echo "✅ Diretório criado"

echo "3️⃣  Definindo permissões corretas..."
chmod 755 ./userDataDir
echo "✅ Permissões definidas"

echo "4️⃣  Reiniciando containers..."
docker-compose up -d

echo "5️⃣  Aguardando inicialização..."
sleep 15

echo "6️⃣  Verificando se está funcionando..."
if curl -s http://localhost:21465/api-docs > /dev/null 2>&1; then
    echo "✅ Servidor funcionando!"
    echo "🌐 Acesse: http://localhost:21465/api-docs"
else
    echo "❌ Servidor não está respondendo"
    echo "Verifique os logs: docker-compose logs -f wppconnect"
fi

echo ""
echo "🎉 Limpeza concluída!"
