import config from '../../../config';

let mongoose: any = null;

if (config.tokenStoreType === 'mongodb') {
  try {
    // @ts-ignore - Ignorar erro de linter para require
    mongoose = require('mongoose');

    const connectOptions = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 10000
    };

    // Teste simples de conexão
    if (!config.db.mongoIsRemote) {
      const userAndPassword =
        config.db.mongodbUser && config.db.mongodbPassword
          ? `${config.db.mongodbUser}:${config.db.mongodbPassword}@`
          : '';

      mongoose.connect(
        `mongodb://${userAndPassword}${config.db.mongodbHost}:${config.db.mongodbPort}/${config.db.mongodbDatabase}`,
        connectOptions
      );
    } else {
      mongoose.connect(config.db.mongoURLRemote, connectOptions);
    }

    // Teste básico de conexão
    mongoose.connection.once('open', () => {
      console.log('✅ MongoDB conectado com sucesso');
    });

    mongoose.connection.on('error', (err: any) => {
      console.error('❌ Erro na conexão MongoDB:', err.message);
    });

  } catch (error) {
    console.error('❌ Erro ao carregar mongoose:', error);
  }
}

export default mongoose;
