// GitHub Pages cannot send custom Content-Encoding headers for stored model buffers.
const originalFetch = globalThis.fetch.bind(globalThis);
globalThis.fetch = async function(input, init) {
  const url = new URL(input instanceof Request ? input.url : input, location.href);
  const models = new URL('models/', location.href);
  if (url.origin !== models.origin || !url.pathname.startsWith(models.pathname) || !url.pathname.endsWith('.bin')) return originalFetch(input, init);
  url.pathname += '.gz';
  const response = await originalFetch(new Request(url, input instanceof Request ? input : undefined), init);
  if (!response.ok || response.headers.get('Content-Encoding') === 'gzip') return response;
  const headers = new Headers(response.headers);
  headers.delete('Content-Length');
  headers.set('Content-Type', 'application/octet-stream');
  return new Response(response.body.pipeThrough(new DecompressionStream('gzip')), {status:response.status, headers});
};
