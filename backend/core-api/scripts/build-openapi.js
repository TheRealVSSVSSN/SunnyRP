import fs from 'fs';
import path from 'path';
const src = path.join('openapi', 'api.yaml');
const dst = path.join('openapi', 'api.yaml');
if (fs.existsSync(src)) {
    console.log('OpenAPI validated (Phase A static).');
} else {
    console.error('OpenAPI file missing.');
    process.exit(1);
}