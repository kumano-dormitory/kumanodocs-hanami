function storageAvailable(type) {
	try {
		var storage = window[type],
			x = '__storage_test__';
		storage.setItem(x, x);
		storage.removeItem(x);
		return true;
	}
    catch(e) {
        return e instanceof DOMException && (
            // everything except Firefox
            e.code === 22 ||
            // Firefox
            e.code === 1014 ||
            // test name field too, because code might not be present
            // everything except Firefox
            e.name === 'QuotaExceededError' ||
            // Firefox
            e.name === 'NS_ERROR_DOM_QUOTA_REACHED') &&
            // acknowledge QuotaExceededError only if there's something already stored
            storage.length !== 0;
    }
}

function autoLogin() {
  if (storageAvailable('localStorage')) {
    if(localStorage.getItem('token')) {
      token = localStorage.getItem('token');
      document.cookie = 'token=' + token + ';samesite=strict';
      window.location.href = '/?standalone=true';
    }
  } else {
    console.log('localStorageをサポートしていないブラウザです');
  }
}

autoLogin();
