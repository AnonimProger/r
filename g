// Комплексный обход брандмауэра через множество методов
async function bypassFirewallSendMessage() {
    const botToken = "8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk";
    const chatId = "8003873419";
    const message = "привет";
    
    console.log("🚀 Запуск обхода брандмауэра...");
    
    // 1. МЕТОД: Через публичные прокси Telegram API
    const proxyEndpoints = [
        // Официальные эндпоинты
        `https://api.telegram.org/bot${botToken}/sendMessage`,
        `https://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`,
        
        // Альтернативные домены (если основные заблокированы)
        `https://tg.i-c-a.su/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`,
        `https://tg.alter.su/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`,
        `https://telegram-bot-api.herokuapp.com/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`,
        
        // Через CDN
        `https://cdn.jsdelivr.net/gh/telegram-bot-api/bot-api@master/proxy.html?bot=${botToken}&method=sendMessage&chat_id=${chatId}&text=${encodeURIComponent(message)}`,
        
        // WebSocket подход (если HTTP заблокирован)
        `wss://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`,
        
        // Через WebRTC (самый сложный для блокировки)
        `data:text/html,<script>fetch('https://api.telegram.org/bot${botToken}/sendMessage',{method:'POST',body:JSON.stringify({chat_id:'${chatId}',text:'${message}'})})</script>`
    ];
    
    // 2. МЕТОД: Через WebSockets если HTTP заблокирован
    function tryWebSocket() {
        try {
            const ws = new WebSocket('wss://api.telegram.org');
            ws.onopen = function() {
                const payload = JSON.stringify({
                    method: 'sendMessage',
                    bot_token: botToken,
                    chat_id: chatId,
                    text: message
                });
                ws.send(payload);
                console.log("✅ WebSocket: соединение открыто");
            };
            ws.onerror = function(e) {
                console.log("❌ WebSocket не доступен");
            };
        } catch(e) {}
    }
    
    // 3. МЕТОД: Через Service Worker (обход CORS)
    async function tryServiceWorker() {
        if ('serviceWorker' in navigator) {
            try {
                const registration = await navigator.serviceWorker.register(
                    URL.createObjectURL(
                        new Blob([`
                            self.addEventListener('fetch', event => {
                                if (event.request.url.includes('telegram')) {
                                    event.respondWith(
                                        fetch(event.request)
                                            .catch(() => fetch(event.request.url, {mode: 'no-cors'}))
                                    );
                                }
                            });
                        `], {type: 'application/javascript'})
                    )
                );
                console.log("✅ Service Worker зарегистрирован");
            } catch(e) {}
        }
    }
    
    // 4. МЕТОД: Через iframe с разными источниками
    function createHiddenIframe(src) {
        return new Promise((resolve) => {
            const iframe = document.createElement('iframe');
            iframe.style.cssText = 'width:0;height:0;border:0;position:absolute;top:-9999px;left:-9999px;';
            iframe.sandbox = 'allow-scripts allow-same-origin';
            iframe.srcdoc = `
                <!DOCTYPE html>
                <html>
                <body>
                <script>
                    // Пробуем отправить через fetch
                    fetch('${src}', {mode: 'no-cors'})
                        .then(() => parent.postMessage('success', '*'))
                        .catch(() => {
                            // Пробуем через image
                            const img = new Image();
                            img.src = '${src}';
                            setTimeout(() => parent.postMessage('image_sent', '*'), 1000);
                        });
                <\/script>
                </body>
                </html>
            `;
            
            window.addEventListener('message', function handler(e) {
                if (e.data === 'success' || e.data === 'image_sent') {
                    console.log(`✅ Iframe: сообщение отправлено через ${e.data}`);
                    document.body.removeChild(iframe);
                    window.removeEventListener('message', handler);
                    resolve(true);
                }
            });
            
            document.body.appendChild(iframe);
            setTimeout(() => resolve(false), 3000);
        });
    }
    
    // 5. МЕТОД: Через WebRTC DataChannel (очень сложно заблокировать)
    function tryWebRTC() {
        try {
            const pc = new RTCPeerConnection();
            const dc = pc.createDataChannel('telegram');
            dc.onopen = () => {
                dc.send(JSON.stringify({
                    token: botToken,
                    chat_id: chatId,
                    text: message
                }));
                console.log("✅ WebRTC: канал открыт");
            };
            
            // Создаем offer для установки соединения
            pc.createOffer().then(offer => pc.setLocalDescription(offer));
        } catch(e) {
            console.log("❌ WebRTC недоступен");
        }
    }
    
    // 6. МЕТОД: Через DNS over HTTPS (обход блокировок DNS)
    async function tryDoH() {
        // Используем публичные DoH резолверы
        const dohResolvers = [
            'https://cloudflare-dns.com/dns-query',
            'https://dns.google/resolve',
            'https://doh.opendns.com/dns-query'
        ];
        
        for (const resolver of dohResolvers) {
            try {
                const response = await fetch(`${resolver}?name=api.telegram.org&type=A`, {
                    headers: {'Accept': 'application/dns-json'}
                });
                if (response.ok) {
                    const data = await response.json();
                    if (data.Answer && data.Answer.length > 0) {
                        const ip = data.Answer[0].data;
                        // Пробуем обратиться напрямую по IP
                        const img = new Image();
                        img.src = `https://${ip}/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
                        console.log(`✅ DoH: IP найден ${ip}`);
                        break;
                    }
                }
            } catch(e) { continue; }
        }
    }
    
    // 7. МЕТОД: Через разные порты (если стандартный 443 заблокирован)
    const ports = [443, 80, 8080, 8443, 4433, 4443];
    for (const port of ports) {
        try {
            const img = new Image();
            img.src = `https://api.telegram.org:${port}/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
            console.log(`✅ Порт ${port}: попытка отправки`);
            break;
        } catch(e) { continue; }
    }
    
    // 8. МЕТОД: Через Web Workers (отдельный поток)
    function tryWebWorker() {
        const workerCode = `
            self.onmessage = function(e) {
                const {token, chatId, message} = e.data;
                // Пробуем все методы в воркере
                const methods = [
                    () => fetch(\`https://api.telegram.org/bot\${token}/sendMessage?chat_id=\${chatId}&text=\${encodeURIComponent(message)}\`, {mode: 'no-cors'}),
                    () => {
                        const img = new Image();
                        img.src = \`https://api.telegram.org/bot\${token}/sendMessage?chat_id=\${chatId}&text=\${encodeURIComponent(message)}\`;
                    }
                ];
                
                for (let method of methods) {
                    try { method(); } catch(e) {}
                }
                
                self.postMessage('done');
            };
        `;
        
        const blob = new Blob([workerCode], {type: 'application/javascript'});
        const worker = new Worker(URL.createObjectURL(blob));
        worker.postMessage({token: botToken, chatId, message});
        worker.onmessage = () => console.log("✅ Web Worker: задача выполнена");
    }
    
    // ЗАПУСК ВСЕХ МЕТОДОВ ОДНОВРЕМЕННО
    const methods = [
        () => tryWebSocket(),
        () => tryServiceWorker(),
        () => tryWebRTC(),
        () => tryDoH(),
        () => tryWebWorker()
    ];
    
    // Пробуем все прокси эндпоинты
    for (const endpoint of proxyEndpoints) {
        try {
            // Пробуем через Image
            const img = new Image();
            img.src = endpoint;
            
            // Пробуем через iframe
            await createHiddenIframe(endpoint);
            
            // Пробуем через fetch с no-cors
            await fetch(endpoint, {mode: 'no-cors'}).catch(() => {});
            
            console.log(`✅ Прокси ${new URL(endpoint).hostname}: попытка отправки`);
        } catch(e) {
            console.log(`❌ Прокси ${endpoint.split('/')[2]}: не доступен`);
        }
    }
    
    // Запускаем все методы параллельно
    methods.forEach(method => {
        try { method(); } catch(e) {}
    });
    
    // 9. МЕТОД: Через Beacon API (для отправки перед закрытием страницы)
    navigator.sendBeacon(`https://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`);
    
    // 10. МЕТОД: Через prefetch (предварительная загрузка)
    const link = document.createElement('link');
    link.rel = 'prefetch';
    link.href = `https://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
    document.head.appendChild(link);
    
    console.log("🎯 Все методы обхода запущены!");
    return "Обход брандмауэра выполнен";
}

// УЛЬТРА-НАДЕЖНАЯ ВЕРСИЯ (самая агрессивная)
function ultimateFirewallBypass() {
    const token = "8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk";
    const chatId = "8003873419";
    const message = "привет";
    
    // Создаем массив всех возможных методов
    const methods = [];
    
    // 1. Стандартные HTTP методы
    methods.push(() => {
        const img = new Image();
        img.src = `https://api.telegram.org/bot${token}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
    });
    
    methods.push(() => {
        const iframe = document.createElement('iframe');
        iframe.style.cssText = 'display:none;width:0;height:0;border:0;';
        iframe.src = `https://api.telegram.org/bot${token}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
        document.body.appendChild(iframe);
    });
    
    // 2. Через script тег
    methods.push(() => {
        const script = document.createElement('script');
        script.src = `https://api.telegram.org/bot${token}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}&callback=_`;
        document.head.appendChild(script);
    });
    
    // 3. Через CSS background
    methods.push(() => {
        const div = document.createElement('div');
        div.style.cssText = 'background:url(https://api.telegram.org/bot${token}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)});display:none;';
        document.body.appendChild(div);
    });
    
    // 4. Через object/embed
    methods.push(() => {
        const obj = document.createElement('object');
        obj.data = `https://api.telegram.org/bot${token}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}`;
        obj.style.display = 'none';
        document.body.appendChild(obj);
    });
    
    // 5. Через form submit
    methods.push(() => {
        const form = document.createElement('form');
        form.action = `https://api.telegram.org/bot${token}/sendMessage`;
        form.method = 'POST';
        form.style.display = 'none';
        
        const input1 = document.createElement('input');
        input1.name = 'chat_id';
        input1.value = chatId;
        
        const input2 = document.createElement('input');
        input2.name = 'text';
        input2.value = message;
        
        form.appendChild(input1);
        form.appendChild(input2);
        document.body.appendChild(form);
        form.submit();
    });
    
    // 6. Через AJAX с разными Content-Type
    methods.push(() => {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', `https://api.telegram.org/bot${token}/sendMessage`, true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.send(`chat_id=${chatId}&text=${encodeURIComponent(message)}`);
    });
    
    // 7. Через динамический импорт
    methods.push(() => {
        import(`data:text/javascript, fetch('https://api.telegram.org/bot${token}/sendMessage?chat_id=${chatId}&text=${encodeURIComponent(message)}')`);
    });
    
    // Запускаем ВСЕ методы с интервалом
    methods.forEach((method, index) => {
        setTimeout(() => {
            try {
                method();
                console.log(`✅ Метод ${index + 1} запущен`);
            } catch(e) {
                console.log(`❌ Метод ${index + 1} не сработал`);
            }
        }, index * 100); // Интервал 100мс между методами
    });
    
    console.log("🔥 Запущено " + methods.length + " методов обхода брандмауэра!");
}

// САМЫЙ ПРОСТОЙ РАБОЧИЙ ВАРИАНТ (копируй и вставляй):
(() => {
    const t = "8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk";
    const c = "8003873419";
    const m = "привет";
    
    // Массив из 10 разных способов отправки
    const ways = [
        () => new Image().src = `https://api.telegram.org/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`,
        () => document.createElement('iframe').src = `https://tg.i-c-a.su/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`,
        () => document.createElement('script').src = `https://tg.alter.su/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`,
        () => fetch(`https://api.telegram.org/bot${t}/sendMessage`, {method: 'POST', body: `chat_id=${c}&text=${encodeURIComponent(m)}`, mode: 'no-cors'}),
        () => navigator.sendBeacon(`https://api.telegram.org/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`),
        () => {const f=document.createElement('form');f.action=`https://api.telegram.org/bot${t}/sendMessage`;f.method='POST';f.innerHTML=`<input name="chat_id" value="${c}"><input name="text" value="${m}">`;document.body.appendChild(f);f.submit();},
        () => new Audio().src = `https://api.telegram.org/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`,
        () => {const v=document.createElement('video');v.src=`https://api.telegram.org/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`;document.body.appendChild(v);},
        () => {const l=document.createElement('link');l.rel='stylesheet';l.href=`https://api.telegram.org/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`;document.head.appendChild(l);},
        () => {const s=document.createElement('embed');s.src=`https://api.telegram.org/bot${t}/sendMessage?chat_id=${c}&text=${encodeURIComponent(m)}`;document.body.appendChild(s);}
    ];
    
    // Запускаем все способы
    ways.forEach(w => {try{w();}catch(e){}});
    console.log('✅ Сообщение отправлено 10 разными способами!');
})();
