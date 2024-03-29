var CACHE_NAME = 'kumanodocs-v2';
var urlsToCache = [
  '/assets/abstruct.svg',
  '/assets/abstruct-dark.svg',
  '/assets/header.jpg',
  '/assets/header-dark.jpg',
  '/assets/favicon-baa44a4725761fc796e4cee42a6e0a19.ico',
  '/assets/logo.png',
  '/assets/application-ce8fa9705b6b390050b60cc62bbd7632.css',
  '/assets/login-e23110b3e84ab1ef9945c19e4c7b452d.css',
  '/assets/top-46fc06f8858f49dca9ad7b660cb54e82.css',
  '/assets/article_reference-296bbe0b7e674a690e12351dce2412e8.js',
  '/assets/auto_login-67fc99363c0697706a5a7ba5cd8863ba.js',
  '/assets/bottom_navigation-aaa86278aa838b77fd487ee767678880.js',
  '/assets/clear_token-43c5db87b423df9117399a3c7cd1f5bc.js',
  '/assets/contextual_menu-c472baff17b453182e265280ae50d60e.js',
  '/assets/dark-f7683084055d1dad6db283706a189c60.js',
  '/assets/diff-fa689e9e74611318f970ad3b0f8575ba.js',
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
