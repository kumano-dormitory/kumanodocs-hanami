var CACHE_NAME = 'kumanodocs-v1';
var urlsToCache = [
  '/assets/abstruct.svg',
  '/assets/header.jpg',
  '/assets/favicon-baa44a4725761fc796e4cee42a6e0a19.ico',
  '/assets/logo.png',
  '/assets/application-ab466f3ba0a045291c522f3c9cf34eb6.css',
  '/assets/login-dbdd349a7795e4d7c3fe0dce21ba316b.css',
  '/assets/top-b51bd883e00cc233a556becfa2486d5e.css',
  '/assets/article_reference-991a46254ffe6e651a95619b73c1ba14.js',
  '/assets/auto_login-67fc99363c0697706a5a7ba5cd8863ba.js',
  '/assets/bottom_navigation-aaa86278aa838b77fd487ee767678880.js',
  '/assets/clear_token-43c5db87b423df9117399a3c7cd1f5bc.js',
  '/assets/contextual_menu-3ddee2caebe357124863783158aff633.js',
  '/assets/diff-e6c7039c1276600292205459db79c949.js',
  '/assets/markdown_preview-eac2ffc7a4be3fc3a4783f21ff46682e.js',
  '/assets/save_token-d2a06de682eb876c81c5bc106abc997f.js',
  '/assets/viewport-1ce191a50c271f107557560ad41c027b.js',
  '/manifest.json',
];

self.addEventListener('install', e => {
  // Perform install steps
  e.waitUntil(precache());
});

self.addEventListener('fetch', e => {
  e.respondWith(fromCache(e.request));
  // e.waitUntil(update(e.request));
});

function precache() {
  return caches.open(CACHE_NAME).then(function(cache) {
    // console.log('Opened cache');
    return cache.addAll(urlsToCache);
  });
}

function fromCache(request) {
  return caches.match(request).then(function (response) {
    if (response) {
      // console.log('cache hit: ' + request.url);
      return response;
    }
    return fetch(request);
  });
}

function update(request) {
  return caches.open(CACHE_NAME).then(function (cache) {
    return cache.match(request).then(function (matching) {
      if (matching) {
        return fetch(request).then(function (response) {
          console.log('cache update: ' + request.url);
          return cache.put(request, response);
        });
      }
    });
  });
}
