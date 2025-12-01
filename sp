setTimeout(()=>window.close(),500);window.open(URL.createObjectURL(new Blob([document.documentElement.outerHTML],{type:'text/html'})),'_blank');
