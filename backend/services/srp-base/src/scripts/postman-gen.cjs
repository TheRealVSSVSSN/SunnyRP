// scripts/postman-gen.cjs
/* eslint-disable */
const fs = require('fs');
const path = require('path');
const converter = require('openapi-to-postmanv2');

const openapiPath = path.join(__dirname, '..', 'openapi', 'api.yaml');
const outPath = path.join(__dirname, '..', 'postman', 'srp-base.generated.postman.json');

const openapi = fs.readFileSync(openapiPath, 'utf8');

converter.convert(
    { type: 'string', data: openapi },
    { folderStrategy: 'Tags' },
    (err, res) => {
        if (err || !res.result) {
            console.error('Conversion failed', err || res.reason);
            process.exit(1);
        }
        if (!fs.existsSync(path.dirname(outPath))) {
            fs.mkdirSync(path.dirname(outPath), { recursive: true });
        }
        fs.writeFileSync(outPath, JSON.stringify(res.output[0].data, null, 2));
        console.log('Postman collection generated at:', outPath);
    }
);