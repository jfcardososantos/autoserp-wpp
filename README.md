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
# Iniciar tudo de uma vez
./start.sh

# Ou manualmente:
docker-compose up -d
```

3. **Testar conexão MongoDB**
```bash
./test-mongo.sh
```

4. **Testar servidor**
```bash
./test-server.sh
```

5. **Verificar logs**
```bash
# Logs do servidor
docker-compose logs -f wppconnect

# Logs do MongoDB
docker-compose logs -f autoserp-mongo
```

## 🔧 Configuração

### Configuração do MongoDB
O arquivo `src/config.ts` permite configurar diferentes tipos de conexão:

```typescript
db: {
  // Para MongoDB local
  mongodbHost: 'localhost',
  mongodbPort: 27017,
  mongodbDatabase: 'tokens',
  mongodbUser: 'user',
  mongodbPassword: 'password',
  mongoIsRemote: false,
  
  // Para MongoDB remoto
  mongoIsRemote: true,
  mongoURLRemote: 'mongodb://user:pass@host:port/database?authSource=admin',
  
  // Para outros bancos (Redis, etc.)
  tokenStoreType: 'mongodb' // ou 'redis', 'file'
}
```

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
```bash
# Parar e remover containers
docker-compose down

# Reconstruir e iniciar
docker-compose up --build
```

### Erro ao Iniciar Sessões
Se você encontrar erros ao iniciar sessões:

1. **Verificar tokens no banco:**
```bash
./check-tokens.sh
```

2. **Testar endpoint start-all:**
```bash
./test-start-sessions.sh
```

3. **Verificar logs do servidor:**
```bash
docker-compose logs -f wppconnect
```

4. **Problemas comuns:**
   - **Nenhum token encontrado**: Crie uma sessão primeiro usando `/api/{secretKey}/create`
   - **Erro de autenticação**: Verifique se o `secretKey` está correto
   - **MongoDB não conectado**: Execute `./test-mongo.sh`

### Testar Conexão MongoDB
```bash
./test-mongo.sh
```

### Verificar Status dos Containers
```bash
docker-compose ps
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

Os logs mostram o status da conexão MongoDB no início:
- ✅ MongoDB conectado com sucesso
- ❌ Erro na conexão MongoDB

Para ajustar o nível de log em `src/config.ts`:
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
