import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ request }) => {
  const clientIP = request.headers.get('quant-client-ip') || 
                   request.headers.get('x-forwarded-for') || 
                   'unknown';
  
  return new Response(
    JSON.stringify({
      message: 'Hello from Astro API!',
      timestamp: new Date().toISOString(),
      clientIP,
      nodeVersion: process.version
    }),
    {
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      }
    }
  );
};

export const POST: APIRoute = async ({ request }) => {
  try {
    const body = await request.json();
    return new Response(
      JSON.stringify({
        message: 'Received POST request',
        data: body,
        timestamp: new Date().toISOString()
      }),
      {
        status: 200,
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: 'Invalid JSON body' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  }
};
