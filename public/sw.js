var CACHE_NAME = 'kumanodocs-v1';
var urlsToCache = [
  '/assets/application.css',
  '/assets/viewport.js',
  '/assets/logo.png',
];

self.addEventListener('install', e => {
  // Perform install steps
  e.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        console.log('Opened cache');
        return cache.addAll(urlsToCache);
      })
  );
});

self.addEventListener('fetch', e => {
  e.respondWith(
    caches.match(e.request)
      .then(function(response) {
        // Cache hit - return response
        if (response) {
          console.log('cache hit: ' + e.request.url);
          return response;
        }
        return fetch(e.request);
      }
    )
  );
});
