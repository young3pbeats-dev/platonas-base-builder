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

---

## Platonas Builder Badge (Soulbound NFT)

**Network:** Base Mainnet  
**Type:** Soulbound (non-transferable)  
**Contract Name:** PlatonasBuilderBadge  
**Contract Address:**  
https://basescan.org/address/0x247a8a7fB7e9517bA19746A262584A2a4652ec70

### Description
A non-transferable Soulbound NFT representing the Platonas Builder identity on Base Mainnet.  
Minted automatically to the contract deployer and used as an on-chain proof of participation in the Platonas builder ecosystem.

### Source Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlatonasBuilderBadge {
    string public name = "Platonas Builder Badge";
    string public symbol = "PLT-BADGE";

    mapping(address => bool) public hasBadge;
    address public owner;

    event BadgeMinted(address indexed to);

    constructor() {
        owner = msg.sender;
        hasBadge[msg.sender] = true;
        emit BadgeMinted(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function mint(address to) external onlyOwner {
        require(!hasBadge[to], "Already has badge");
        hasBadge[to] = true;
        emit BadgeMinted(to);
    }

    // Soulbound: non trasferibile
    function transferFrom(address, address, uint256) public pure returns (bool) {
        revert("Soulbound: non-transferable");
    }

    function approve(address, uint256) public pure returns (bool) {
        revert("Soulbound: non-transferable");
    }
}
```
## Plato Storage Contract

**Network:** Base Mainnet
**Contract Name:** PlatoStorage
**Contract Address:** 
https://basescan.org/address/0xB2d87d21783Eb0c820daafD9754E7a8e5C7334b3

**Source Code**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract PlatoStorage {
    uint256 private value;

    event ValueUpdated(uint256 oldValue, uint256 newValue, address updatedBy);

    function setValue(uint256 newValue) public {
        uint256 old = value;
        value = newValue;
        emit ValueUpdated(old, newValue, msg.sender);
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
```

## Plato Allowlist Contract

**Network:** Base Mainnet  
**Contract Name:** PlatoAllowlist  
**Contract Address:**  
https://basescan.org/address/0xDEf5F7D338cc94028C0C30240B3aB99aB1513Ec6  

**Source Code**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlatoAllowlist {
    address public owner;

    mapping(address => bool) public isAllowed;

    event AddedToAllowlist(address indexed account);
    event RemovedFromAllowlist(address indexed account);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function add(address account) external onlyOwner {
        require(!isAllowed[account], "Already allowed");
        isAllowed[account] = true;
        emit AddedToAllowlist(account);
    }

    function remove(address account) external onlyOwner {
        require(isAllowed[account], "Not in allowlist");
        isAllowed[account] = false;
        emit RemovedFromAllowlist(account);
    }

    function check(address account) external view returns (bool) {
        return isAllowed[account];
    }
}
```
