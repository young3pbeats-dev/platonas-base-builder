# platonas-base-builder

Building on Base – first verified contracts deployed on Base Mainnet.

## BaseHello Contract

**Network:** Base Mainnet (chainId 8453)  
**Contract Name:** BaseHello  
**Deployed Contract:**  
https://basescan.org/address/0x4B022DceDA283F9c21441AdffeF758694B59F261

## Source Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BaseHello {
    string public message;

    constructor() {
        message = "Hello Base Mainnet!";
    }

    function setMessage(string calldata newMessage) external {
        message = newMessage;
    }
}
```
## Platonas Token (ERC20)
**Network:** Base Mainnet
**Symbol:** PLATONAS
**Total Supply:** 1,000,000 PLATONAS
**Contract:** https://basescan.org/address/0xBD8BbB91213AfaFC8342acbb383e99C094dC1C99

