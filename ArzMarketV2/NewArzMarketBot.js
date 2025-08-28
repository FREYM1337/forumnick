const { TelegramClient } = require('telegram'); 
const { StringSession } = require('telegram/sessions'); 
const readline = require('readline');
const fs = require('fs');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});


function askQuestion(query) {
    return new Promise(resolve => rl.question(query, resolve));
}


function loadConfig() {
    try {
        const data = fs.readFileSync('./config.json', 'utf-8');
        const config = JSON.parse(data);
        return {
            sessionString: config.sessionString,
            API_ID: config.API_ID || 0,
            API_HASH: config.API_HASH || '',
            interval: config.interval || 3600000, 
            saveSession: config.saveSession !== undefined ? config.saveSession : true 
        };
    } catch (error) {
        console.log('Не удалось прочитать файл config.json или он не существует. Создаем новый файл с пустыми параметрами.');

        
        const defaultConfig = {
            sessionString: '',
            API_ID: 0,
            API_HASH: '',
            interval: 3600000, 
            saveSession: true 
        };

        fs.writeFileSync('./config.json', JSON.stringify(defaultConfig, null, 2), 'utf-8');
        console.log('Новый файл config.json создан с пустыми параметрами.');

        
        return defaultConfig;
    }
}

(async () => {
    let { sessionString, API_ID, API_HASH, interval, saveSession } = loadConfig();
    const session = new StringSession(sessionString);
    const client = new TelegramClient(session, API_ID, API_HASH, { connectionRetries: 5 });

    console.log('Подключение к Telegram.');

    
    if (!sessionString) {
        await client.start({
            phoneNumber: async () => await askQuestion("Введите номер телефона: "),
            password: async () => await askQuestion("Пароль: "),
            phoneCode: async () => await askQuestion("Введите код подтверждения для входа: "),
            onError: (err) => {
                console.error('Ошибка при аутентификации:', err);
                return Promise.resolve(false);
            }
        });

        console.log('Соединение установлено.');

        
        if (saveSession) {
            const newSessionString = client.session.save();
            const authData = {
                sessionString: newSessionString,
                API_ID: API_ID,
                API_HASH: API_HASH,
                interval: interval, 
                saveSession: saveSession 
            };

            fs.writeFileSync('./config.json', JSON.stringify(authData, null, 2), 'utf-8');
            console.log('Токен авторизации и данные чатов сохранены в config.json');
        }
    } else {
        await client.connect(); 
        console.log('Успешно подключено с использованием сохраненной сессии.');
    }

    
    const forwardMessages = async () => {
        
        let { interval } = loadConfig();


        try {
            const messages = await client.getMessages('@ArzMarketTOS_Bot', { limit: 1 }); 

            if (messages.length > 0) {
                const lastMessage = messages[0];
                if (lastMessage.message || lastMessage.media) {
                    await client.sendMessage('@arzmarket_vice', {
                        message: lastMessage.message || undefined, 
                        file: lastMessage.media 
                    });
                    console.log(`Отправлена реклама в чат @arzmarket_vice: ${lastMessage.message}`);
                } else {
                    console.log('Нет текста и медиа для пересылки.');
                }
            } else {
                console.log('Нет сообщений для пересылки.');
            }
        } catch (error) {
            console.error('Ошибка при пересылке сообщений:', error);
        }

        
        setTimeout(forwardMessages, interval);
    };

    
    forwardMessages();

})();
