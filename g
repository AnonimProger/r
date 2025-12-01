// Функция отправки "привет" с использованием ваших данных
async function sendHello() {
    const botToken = "8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk";
    const chatId = "8003873419";
    const message = "привет";
    
    console.log("📤 Отправка сообщения...");
    
    // Метод 1: Через Image (самый надежный, обходит CORS)
    try {
        const img = new Image();
        img.style.display = 'none';
        img.src = `https://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
        document.body.appendChild(img);
        console.log("✅ Метод Image: запрос отправлен");
    } catch (e) {
        console.log("❌ Метод Image не сработал:", e.message);
    }
    
    // Метод 2: Через fetch с FormData
    try {
        const formData = new FormData();
        formData.append('chat_id', chatId);
        formData.append('text', message);
        
        const response = await fetch(`https://api.telegram.org/bot${botToken}/sendMessage`, {
            method: 'POST',
            body: formData
        });
        
        if (response.ok) {
            console.log("✅ Fetch метод: сообщение отправлено успешно");
        } else {
            console.log("❌ Fetch метод: ошибка", response.status);
        }
    } catch (e) {
        console.log("❌ Fetch метод не сработал:", e.message);
    }
    
    // Метод 3: Через iframe
    try {
        const iframe = document.createElement('iframe');
        iframe.style.display = 'none';
        iframe.src = `https://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
        document.body.appendChild(iframe);
        console.log("✅ Iframe метод: запрос отправлен");
    } catch (e) {
        console.log("❌ Iframe метод не сработал");
    }
    
    console.log("🎯 Все методы попытки завершены");
}

// Минимальная версия (самая эффективная)
function sendHelloSimple() {
    const img = new Image();
    img.src = `https://api.telegram.org/bot8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk/sendMessage?chat_id=8003873419&text=привет`;
    console.log("Привет отправлено!");
}

// Версия для немедленного выполнения
(function() {
    const botToken = "8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk";
    const chatId = "8003873419";
    
    // Создаем и отправляем запрос через Image
    const telegramUrl = `https://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=привет`;
    
    const img = document.createElement('img');
    img.style.width = '0';
    img.style.height = '0';
    img.style.position = 'absolute';
    img.style.opacity = '0';
    img.src = telegramUrl;
    
    document.body.appendChild(img);
    
    // Дублируем через iframe для надежности
    const iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    iframe.src = telegramUrl;
    document.body.appendChild(iframe);
    
    console.log('✅ Сообщение "привет" отправлено пользователю 8003873419');
})();
