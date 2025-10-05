import Fastify from 'fastify';
import { Pool } from 'pg';

const fastify = Fastify({ logger: true });
const PORT = 3000;

// PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://your_user:your_password@localhost:5432/your_database'
});

// Thing interface
interface Thing {
  id: string;
  name: string;
}

// GET endpoint to retrieve all things
fastify.get('/things', async (request, reply) => {
  try {
    const result = await pool.query('SELECT id, name FROM things ORDER BY id');
    return result.rows;
  } catch (error) {
    fastify.log.error(error);
    return reply.status(500).send({ error: 'Internal server error' });
  }
});

// GET endpoint to retrieve a thing by id
fastify.get<{ Params: { id: string } }>('/things/:id', async (request, reply) => {
  const { id } = request.params;
  
  try {
    const result = await pool.query(
      'SELECT id, name FROM things WHERE id = $1',
      [id]
    );
    
    if (result.rows.length === 0) {
      return reply.status(404).send({ error: 'Thing not found' });
    }
    
    return result.rows[0];
  } catch (error) {
    fastify.log.error(error);
    return reply.status(500).send({ error: 'Internal server error' });
  }
});

// Start server
const start = async () => {
  try {
    await fastify.listen({ port: PORT, host: '0.0.0.0' });
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();