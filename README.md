# platonas-base-builder 🟦

A clean, transparent portfolio of my verified smart contracts deployed on **Base Mainnet (chainId 8453)**.  
This repository documents my Solidity learning journey and the on-chain tools I build to develop my reputation as an early Base builder.

---

## 🔹 BaseHello.sol  
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0x4B022DceDA283F9c21441AdffeF758694B59F261  

A minimal “Hello Base” contract used to test my full deployment → verification workflow on Base Mainnet.

---

## 🔹 PlatonasToken.sol  
**Network:** Base Mainnet  
**Symbol:** PLATONAS  
**Supply:** 1,000,000 PLATONAS  
**Address:** https://basescan.org/address/0xBD8BbB91213AfaFC8342acbb383e99C094dC1C99  

An educational ERC20-style token used to practice balance mappings, transfer logic and event emission.

---

## 🔹 PlatonasBuilderBadge.sol (Soulbound Badge)  
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0x247a8a7fB7e9517bA19746A262584A2a4652ec70  

A non-transferable badge minted to the deployer.  
Represents identity, participation and activity within my builder path on Base Mainnet.

---

## 🔹 PlatoStorage.sol  
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0xB2d87d21783Eb0c820daafD9754E7a8e5C7334b3  

A simple storage contract demonstrating persistent state, update events and read/write patterns.

---

## 🔹 PlatoAllowlist.sol  
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0xDEf5F7D338cc94028C0C30240B3aB99aB1513Ec6  

A basic access-control contract using a boolean mapping and an owner-only modifier.

---

## 🔹 DailyChecklistTracker.sol  
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0x416A60fd2310f021A1143f08bFa4d80034DA0C34  
**Type:** Habit & self-discipline tracker  

Tracks daily habits (exercise, meditation, no-porn, no-alcohol) and computes streaks of consecutive successful days.  
A personal on-chain reputation tool designed to show consistency, growth, and human behavior—not sybil activity.

---

## 🔹 PlatonasReputation.sol   
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0xFe88f67499852Df3Dd21e2eF1BCfd00890F8F55b
**Type:** On-chain reputation registry  

A curated reputation system storing multiple human-driven scores:
- builderScore (verified smart-contract work)  
- defiScore (interaction footprint)  
- socialScore (community participation)  
- consistencyScore (long-term activity)  

Includes curator permissions and a weighted total reputation score.  
Built to serve as the central “identity engine” of the Platonas builder ecosystem.

---

## 🔹 SessionBasedChecklistTracker.sol  

**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0x1a4CcEC8d5Fbe9839CAB34e256863837bA8EEFF0  
**Type:** Session-based self-discipline tracker  

A session-based version of my discipline tracker:
- each log is a "session" (not tied to calendar days)  
- sessionId auto-incremental per user  
- stores per-user history with notes  
- computes streaks of consecutive successful sessions  

Built to complement `DailyChecklistTracker.sol` and provide a more flexible consistency signal on-chain.

---

## 🔹 MicroAMM.sol ⚙️
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0x9569552C4F5c9aCdd0C2C1F5A026447659662228  
**Type:** Educational Automated Market Maker (DeFi prototype)

A minimal Automated Market Maker (AMM) designed to demonstrate core DeFi mechanics on Base Mainnet.  
Implements a tokenA/tokenB liquidity pool using the constant product formula (x * y = k), enabling basic swaps, liquidity additions, withdrawals, and event tracking for pool operations.

Purpose: Provide a clear technical showcase of AMM fundamentals within the Platonas Base Builder portfolio.

---

## 🔹TimeLockedAccount

**Network:** Base Mainnet 
**Address:** https://basescan.org/address/0xeE0Ce321398D010c8E1deB99f33966480b596bA7
**Type:** Time-Locked Vault / Account Abstraction Utility

A minimal time-locked smart contract designed to securely hold ETH and ERC20 tokens until a predefined unlock timestamp.
Funds deposited into the contract remain inaccessible until the unlockTime condition is met, after which withdrawals can be executed by the owner or a designated beneficiary.

The contract supports native ETH deposits via receive() and ERC20 deposits via explicit approval, making it suitable for delayed payouts, vesting-like mechanisms, escrow-style flows, and self-custodial time-based fund management on Base Mainnet.

Purpose: Provide a clean and practical example of time-lock mechanics and secure conditional withdrawals within the Platonas Base Builder portfolio.

---

## 🔹 CrossChainPriceFeed.sol
**Network:** Base Mainnet  
**Address:** https://basescan.org/address/0x24C1c6a115Ed12Cd3Fe0d2E8e4d27525ed1A1b57  

A minimal oracle-style contract that allows manual, role-based price updates to simulate cross-chain data feeds on Base Mainnet.

Designed to demonstrate oracle architecture, authorization patterns, and clean data access, while remaining compatible with future integrations such as CCIP, LayerZero, or custom relayers.

Core features:
- Manual oracle-based price updates  
- Role-based authorization for feed updates  
- Timestamped price storage (stale data protection)  
- Multi-asset feed support (e.g. ETH/USD, BTC/USD)  
- Source chain context via `sourceChainId`  

Reason: Oracles are the backbone of DeFi. This contract demonstrates real-world architecture beyond simple storage primitives while remaining honest about off-chain data delivery.

---

🔹 PriceFeedRegistry.sol ⚙️

**Network:** Base Mainnet
**Address:** (https://basescan.org/address/0x9DdB82a4855B5fD73D9F12b2348E9AEb217D7FF5)
**Type:** Advanced Oracle Registry / Price Feed Aggregator

📌 Overview

PriceFeedRegistry is a modular on-chain registry designed to manage multiple oracle price submissions per asset and compute a median-based aggregated price, improving resistance against manipulation and single-oracle failure.

The contract is built as a core oracle primitive for future extensions such as reputation-weighted oracles, staking-based oracle incentives, and cross-chain price relayers.

--- 

## Project Board  
All contracts, ideas and next steps are organized in my GitHub Project:

**➡️ Base Builder Portfolio** (Projects tab)

- Completed Contracts  
- In Progress  
- Future Ideas  

---

## 🎯 Purpose  
- Build a verifiable on-chain track record on Base  
- Learn Solidity by deploying and verifying real contracts  
- Explore reputation systems and small DeFi patterns  
- Document consistent human activity (not sybil behavior)  
- Grow as an early builder within the Base ecosystem
