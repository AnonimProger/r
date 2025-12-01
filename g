import urllib.request
import urllib.parse
import json

# Ваши данные
BOT_TOKEN = "8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk"
CHAT_ID = "8003873419"
MESSAGE = "привет"

print("📤 Отправка сообщения в Telegram...")

try:
    # URL для отправки
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    
    # Параметры запроса
    params = {
        "chat_id": CHAT_ID,
        "text": MESSAGE
    }
    
    # Кодируем параметры
    data = urllib.parse.urlencode(params).encode('utf-8')
    
    # Создаем и отправляем запрос
    req = urllib.request.Request(url, data=data)
    response = urllib.request.urlopen(req, timeout=10)
    
    # Читаем ответ
    result = json.loads(response.read().decode('utf-8'))
    
    if result.get("ok"):
        print("✅ Сообщение 'привет' успешно отправлено!")
    else:
        print(f"❌ Ошибка: {result}")
        
except Exception as e:
    print(f"❌ Ошибка отправки: {e}")
