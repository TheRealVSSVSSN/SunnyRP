import { writeFileSync } from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import swaggerJSDoc from 'swagger-jsdoc';
import { stringify } from 'yaml';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const options = {
  definition: {
    openapi: '3.0.0',
    info: { title: 'SRP Base API', version: '0.1.0' },
    security: [ { hmacAuth: [] } ],
    components: {
      securitySchemes: {
        hmacAuth: {
          type: 'apiKey',
          in: 'header',
          name: 'x-srp-signature'
        },
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      },
      parameters: {
        IdempotencyKey: {
          name: 'Idempotency-Key',
          in: 'header',
          required: true,
          schema: { type: 'string' },
          description: 'Idempotency key for safely retrying requests'
        }
      }
    }
  },
  apis: [path.join(__dirname, 'routes/*.js')]
};

const spec = swaggerJSDoc(options);
const yaml = stringify(spec);
writeFileSync(path.join(__dirname, '../docs/openapi.yaml'), yaml);
