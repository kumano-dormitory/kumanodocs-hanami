var CACHE_NAME = 'kumanodocs-v1';
var urlsToCache = [
  '/assets/abstruct.svg',
  '/assets/header.jpg',
  '/assets/application.css',
  '/assets/login.css',
  '/assets/article_reference.js',
  '/assets/auto_login.js',
  '/assets/bottom_navigation.js',
  '/assets/clear_token.js',
  '/assets/contextual_menu.js',
  '/assets/save_token.js',
  '/assets/viewport.js',
  '/assets/logo.png',
  '/manifest.json',
];

self.addEventListener('install', e => {
  // Perform install steps
  e.waitUntil(precache());
});

self.addEventListener('fetch', e => {
  e.respondWith(fromCache(e.request));
  e.waitUntil(update(e.request));
});

function precache() {
  return caches.open(CACHE_NAME).then(function(cache) {
    console.log('Opened cache');
    return cache.addAll(urlsToCache);
  });
}

function fromCache(request) {
  return caches.match(request).then(function (response) {
    if (response) {
      console.log('cache hit: ' + request.url);
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
