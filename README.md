# Blockchain Case Study - Drug Supply Chain Management System

## 📋 Project Overview

This project implements a blockchain-based drug supply chain management system using Ethereum smart contracts written in Solidity. The system provides a transparent, secure, and immutable way to track pharmaceutical products from manufacturers through the entire supply chain to end customers, helping to combat counterfeit drugs and ensure drug authenticity.

The solution leverages blockchain technology to create an auditable trail of drug batches, allowing stakeholders to verify the origin, ownership, and authenticity of pharmaceutical products at any point in the supply chain.

## ✨ Features

- **Manufacturer Registration**: Secure registration system for pharmaceutical manufacturers with registration fees
- **Batch Management**: Create and track drug batches with detailed information including batch ID, product name, manufacture date, and expiry date
- **Ownership Transfer**: Transfer batch ownership between supply chain participants (manufacturers, distributors, retailers)
- **Drug Verification**: Customer portal for verifying drug authenticity using batch IDs
- **Immutable Records**: All transactions are recorded on the blockchain, providing tamper-proof audit trails
- **Access Control**: Role-based permissions ensuring only registered manufacturers can create batches

## 🏗️ Architecture

The system consists of three main smart contracts:

### 1. ManufacturerRegistry.sol
Manages the registration and verification of pharmaceutical manufacturers.

**Key Functions:**
- `registerManufacturer(string _name)`: Register a new manufacturer with a registration fee
- `isRegistered(address manufacturer)`: Check if an address is a registered manufacturer
- `setRegistrationFee(uint256 newFee)`: Update registration fee (owner only)

**Key Features:**
- Registration fee mechanism to prevent spam
- Owner-controlled administration
- Timestamp tracking for registrations

### 2. SupplyChain.sol
Core contract for managing drug batches and ownership transfers.

**Key Functions:**
- `createBatch(string batchId, string productName, uint256 manufactureDate, uint256 expiryDate)`: Create a new drug batch
- `transferOwnership(string batchId, address to)`: Transfer batch ownership
- `getBatch(string batchId)`: Retrieve batch information

**Key Features:**
- Batch creation restricted to registered manufacturers
- Ownership tracking throughout the supply chain
- Event emission for transparency

### 3. CustomerPortal.sol
Public interface for customers to verify drug authenticity.

**Key Functions:**
- `verifyDrug(string batchId)`: Verify drug information and authenticity

**Key Features:**
- Public access for drug verification
- Returns product name, manufacturer, current owner, and validity status

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v14.0.0 or higher) - [Download](https://nodejs.org/)
- **npm** or **yarn** - Comes with Node.js
- **Git** - [Download](https://git-scm.com/)

### Development Environment Options

Choose one of the following Ethereum development frameworks:

#### Option 1: Hardhat (Recommended)
```bash
npm install --save-dev hardhat
```

#### Option 2: Truffle
```bash
npm install -g truffle
```

#### Option 3: Foundry
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Additional Tools

- **MetaMask** - Browser extension for Ethereum wallet ([Download](https://metamask.io/))
- **Ganache** - Local Ethereum blockchain for testing (Optional) - [Download](https://trufflesuite.com/ganache/)

## 📥 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Gautam-04/Blockchain-Case-Study.git
cd Blockchain-Case-Study
```

### 2. Install Dependencies

#### For Hardhat:

```bash
npm init -y
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npm install --save-dev @nomiclabs/hardhat-ethers ethers
```

Initialize Hardhat:
```bash
npx hardhat
```
Select "Create an empty hardhat.config.js" when prompted.

#### For Truffle:

```bash
npm init -y
npm install --save-dev truffle
truffle init
```

#### For Foundry:

```bash
forge init --no-git
```

### 3. Configure the Development Environment

#### Hardhat Configuration

Create or update `hardhat.config.js`:

```javascript
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.19",
  networks: {
    hardhat: {
      chainId: 1337
    },
    localhost: {
      url: "http://127.0.0.1:8545"
    }
  }
};
```

#### Truffle Configuration

Update `truffle-config.js`:

```javascript
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    }
  },
  compilers: {
    solc: {
      version: "0.8.19"
    }
  }
};
```

## 🚀 Usage

### Compile Smart Contracts

#### Hardhat:
```bash
npx hardhat compile
```

#### Truffle:
```bash
truffle compile
```

#### Foundry:
```bash
forge build
```

### Deploy Smart Contracts

#### Using Hardhat

1. Create a deployment script `scripts/deploy.js`:

```javascript
async function main() {
  // Deploy ManufacturerRegistry
  const registrationFee = ethers.utils.parseEther("0.01"); // 0.01 ETH
  const ManufacturerRegistry = await ethers.getContractFactory("ManufacturerRegistry");
  const registry = await ManufacturerRegistry.deploy(registrationFee);
  await registry.deployed();
  console.log("ManufacturerRegistry deployed to:", registry.address);

  // Deploy SupplyChain
  const SupplyChain = await ethers.getContractFactory("SupplyChain");
  const supplyChain = await SupplyChain.deploy(registry.address);
  await supplyChain.deployed();
  console.log("SupplyChain deployed to:", supplyChain.address);

  // Deploy CustomerPortal
  const CustomerPortal = await ethers.getContractFactory("CustomerPortal");
  const portal = await CustomerPortal.deploy(supplyChain.address);
  await portal.deployed();
  console.log("CustomerPortal deployed to:", portal.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

2. Start local blockchain:
```bash
npx hardhat node
```

3. Deploy (in a new terminal):
```bash
npx hardhat run scripts/deploy.js --network localhost
```

#### Using Truffle

1. Create a migration file `migrations/2_deploy_contracts.js`:

```javascript
const ManufacturerRegistry = artifacts.require("ManufacturerRegistry");
const SupplyChain = artifacts.require("SupplyChain");
const CustomerPortal = artifacts.require("CustomerPortal");

module.exports = async function(deployer) {
  const registrationFee = web3.utils.toWei("0.01", "ether");
  
  await deployer.deploy(ManufacturerRegistry, registrationFee);
  const registry = await ManufacturerRegistry.deployed();
  
  await deployer.deploy(SupplyChain, registry.address);
  const supplyChain = await SupplyChain.deployed();
  
  await deployer.deploy(CustomerPortal, supplyChain.address);
};
```

2. Deploy:
```bash
truffle migrate
```

### Interact with Contracts

#### Hardhat Console:
```bash
npx hardhat console --network localhost
```

Example interactions:
```javascript
const registry = await ethers.getContractAt("ManufacturerRegistry", "<REGISTRY_ADDRESS>");
const supplyChain = await ethers.getContractAt("SupplyChain", "<SUPPLY_CHAIN_ADDRESS>");

// Register a manufacturer
await registry.registerManufacturer("Pharma Corp", { value: ethers.utils.parseEther("0.01") });

// Create a batch
await supplyChain.createBatch("BATCH001", "Aspirin", Date.now(), Date.now() + 31536000000);

// Get batch information
const batch = await supplyChain.getBatch("BATCH001");
console.log(batch);
```

#### Truffle Console:
```bash
truffle console
```

Example interactions:
```javascript
let registry = await ManufacturerRegistry.deployed();
let supplyChain = await SupplyChain.deployed();

// Register a manufacturer
await registry.registerManufacturer("Pharma Corp", { value: web3.utils.toWei("0.01", "ether") });

// Create a batch
await supplyChain.createBatch("BATCH001", "Aspirin", Math.floor(Date.now()/1000), Math.floor(Date.now()/1000) + 31536000);
```

## 🧪 Testing

### Create Test Files

#### Hardhat Test Example (`test/SupplyChain.test.js`):

```javascript
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Supply Chain System", function() {
  let registry, supplyChain, portal;
  let owner, manufacturer, customer;

  beforeEach(async function() {
    [owner, manufacturer, customer] = await ethers.getSigners();
    
    const ManufacturerRegistry = await ethers.getContractFactory("ManufacturerRegistry");
    registry = await ManufacturerRegistry.deploy(ethers.utils.parseEther("0.01"));
    
    const SupplyChain = await ethers.getContractFactory("SupplyChain");
    supplyChain = await SupplyChain.deploy(registry.address);
    
    const CustomerPortal = await ethers.getContractFactory("CustomerPortal");
    portal = await CustomerPortal.deploy(supplyChain.address);
  });

  it("Should register manufacturer and create batch", async function() {
    await registry.connect(manufacturer).registerManufacturer("Test Pharma", {
      value: ethers.utils.parseEther("0.01")
    });
    
    expect(await registry.isRegistered(manufacturer.address)).to.be.true;
    
    await supplyChain.connect(manufacturer).createBatch(
      "BATCH001",
      "Medicine",
      Date.now(),
      Date.now() + 31536000000
    );
    
    const batch = await supplyChain.getBatch("BATCH001");
    expect(batch.exists).to.be.true;
  });
});
```

Run tests:
```bash
npx hardhat test
```

## 🌐 Deployment to Test Networks

### Deploy to Goerli/Sepolia Testnet

1. Get testnet ETH from a faucet:
   - Goerli: https://goerlifaucet.com/
   - Sepolia: https://sepoliafaucet.com/

2. Update `hardhat.config.js` with network configuration:

```javascript
require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};
```

3. Create a `.env` file:
```
INFURA_PROJECT_ID=your_infura_project_id
PRIVATE_KEY=your_wallet_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

4. Deploy:
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

## 📚 Smart Contract Workflow

1. **Setup Phase**:
   - Deploy `ManufacturerRegistry` contract
   - Deploy `SupplyChain` contract with registry address
   - Deploy `CustomerPortal` contract with supply chain address

2. **Manufacturer Registration**:
   - Manufacturer calls `registerManufacturer()` with registration fee
   - Registry stores manufacturer details

3. **Batch Creation**:
   - Registered manufacturer calls `createBatch()` with product details
   - Batch is created with manufacturer as initial owner

4. **Supply Chain Movement**:
   - Current owner calls `transferOwnership()` to transfer to next party
   - Ownership is updated on blockchain

5. **Customer Verification**:
   - Customer uses `verifyDrug()` via portal to check authenticity
   - System returns product details and validation status

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Gautam-04 - [GitHub Profile](https://github.com/Gautam-04)

## 🙏 Acknowledgments

- OpenZeppelin for smart contract best practices
- Ethereum Foundation for blockchain technology
- The Solidity community for documentation and support

## 📞 Contact

For questions or support, please open an issue in the GitHub repository.

---

**Note**: This is an educational project demonstrating blockchain implementation for supply chain management. For production use, additional security audits and testing are recommended.
