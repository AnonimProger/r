(()=>{
const t="8576877446:AAGQUbwtIw2AGyDl-JE1JOslk7fjhf0hgsk",c="8003873419",m="привет";
[1,2,3,4,5,6,7,8,9,10].forEach(i=>{
try{new Image().src=`https://api.telegram.org/bot${t}/sendMessage?chat_id=${c}&text=${m}&v=${i}`}catch(e){}
try{document.createElement('iframe').src=`https://tg.i-c-a.su/bot${t}/sendMessage?chat_id=${c}&text=${m}&v=${i}`}catch(e){}
});
console.log('✅ 20 попыток отправки запущены!');
})()
