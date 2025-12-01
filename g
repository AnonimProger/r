# Код для Python 3.4.3
import urllib.request
import urllib.parse

# Формируем URL
url = "https://api.telegram.org/bot8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk/sendMessage"

# Данные для отправки
params = {'chat_id': '8003873419', 'text': 'привет'}

# Кодируем данные
data = urllib.parse.urlencode(params)
data = data.encode('utf-8')

# Создаем запрос
req = urllib.request.Request(url, data=data)

# Отправляем
try:
    response = urllib.request.urlopen(req)
    print("Сообщение отправлено успешно!")
except Exception as e:
    print("Ошибка:", e)
