# Testing Notes

Automated test suites are not yet implemented. Manually verify the diamond blackjack endpoints after deployment:

```sh
curl -H 'X-API-Token: <token>' http://localhost:3010/v1/diamond-blackjack/hands/char123
```
