# WPPConnect Server

Servidor para autenticação e automação do WhatsApp Web com múltiplos clientes de forma dinâmica.

## 🚀 Início Rápido

### Pré-requisitos
- Docker e Docker Compose instalados
- Node.js 22.18.0 ou superior

### Instalação e Execução

1. **Clone o repositório**
```bash
git clone <seu-repositorio>
cd autoserp-wpp
```

2. **Inicie os serviços**
```bash
# Iniciar MongoDB primeiro
docker-compose up -d autoserp-mongo

# Aguardar MongoDB estar disponível e iniciar servidor
./start.sh
```

3. **Verificar logs**
```bash
# Logs do servidor
docker-compose logs -f wppconnect

# Logs do MongoDB
docker-compose logs -f autoserp-mongo
```

## 🔧 Configuração

### Variáveis de Ambiente
As principais configurações estão no arquivo `src/config.ts`:

- **Porta do servidor**: 21465
- **MongoDB**: Configurado para usar container Docker
- **Webhook**: Configurado para enviar eventos

### Estrutura do Projeto
```
src/
├── config/          # Configurações
├── controller/      # Controladores da API
├── middleware/      # Middlewares
├── routes/          # Rotas da API
├── util/            # Utilitários
│   ├── db/         # Configuração de banco de dados
│   └── tokenStore/ # Gerenciamento de tokens
└── server.ts        # Arquivo principal do servidor
```

## 🐛 Solução de Problemas

### Erro de Autenticação MongoDB
Se você encontrar erro de autenticação:
```bash
# Parar todos os containers
docker-compose down

# Remover volumes (cuidado: isso apaga os dados)
docker-compose down -v

# Reconstruir e iniciar
docker-compose up --build
```

### Erro de Conexão
Se o servidor não conseguir conectar ao MongoDB:
1. Verifique se o MongoDB está rodando: `docker-compose ps`
2. Verifique os logs: `docker-compose logs autoserp-mongo`
3. Aguarde o healthcheck passar antes de iniciar o servidor

### Porta em Uso
Se a porta 21465 estiver em uso:
```bash
# Verificar processos usando a porta
lsof -i :21465

# Parar processo se necessário
kill -9 <PID>
```

## 📚 API

### Documentação Swagger
Após iniciar o servidor, acesse:
```
http://localhost:21465/api-docs
```

### Endpoints Principais
- `POST /api/{secretKey}/start-all` - Iniciar todas as sessões
- `POST /api/{secretKey}/create` - Criar nova sessão
- `GET /api/{secretKey}/status` - Status das sessões

## 🔒 Segurança

- **Secret Key**: Configure uma chave secreta forte em `src/config.ts`
- **MongoDB**: Usuário e senha configurados no docker-compose
- **Webhook**: Configure URLs seguras para webhooks

## 📝 Logs

Os logs são configurados para mostrar informações detalhadas. Para produção, considere ajustar o nível de log em `src/config.ts`:

```typescript
log: {
  level: 'info', // 'silly', 'debug', 'info', 'warn', 'error'
  logger: ['console', 'file']
}
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença Apache 2.0 - veja o arquivo [LICENSE](LICENSE) para detalhes.
