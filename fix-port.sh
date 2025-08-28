#!/bin/bash

echo "🔧 Corrigindo problemas de porta..."
echo "=================================="

# Verificar se o servidor está rodando na porta correta
echo "1️⃣  Verificando porta atual..."
if curl -s http://localhost:21465/api-docs > /dev/null 2>&1; then
    echo "✅ Servidor rodando na porta correta (21465)"
    echo "🎉 Nenhuma correção necessária!"
    exit 0
fi

echo "❌ Servidor não está na porta 21465"

# Verificar se está na porta 80
if curl -s http://localhost:80/api-docs > /dev/null 2>&1; then
    echo "⚠️  Servidor rodando na porta incorreta (80)"
    
    echo ""
    echo "2️⃣  Corrigindo porta..."
    echo "Parando containers..."
    docker-compose down
    
    echo "Reconstruindo com configuração correta..."
    docker-compose up --build -d
    
    echo "Aguardando inicialização..."
    sleep 15
    
    echo "3️⃣  Verificando correção..."
    if curl -s http://localhost:21465/api-docs > /dev/null 2>&1; then
        echo "✅ Porta corrigida! Servidor rodando na porta 21465"
    else
        echo "❌ Falha na correção. Verifique os logs:"
        echo "   docker-compose logs -f wppconnect"
        exit 1
    fi
else
    echo "❌ Servidor não está respondendo em nenhuma porta conhecida"
    echo "Verifique se os containers estão rodando:"
    echo "   docker-compose ps"
    exit 1
fi

echo ""
echo "🎉 Correção concluída com sucesso!"
echo "🌐 Acesse: http://localhost:21465/api-docs"
