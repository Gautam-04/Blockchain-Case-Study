// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ManufacturerRegistry.sol";

contract SupplyChain {
    ManufacturerRegistry public registry;

    struct Batch {
        string batchId;
        string productName;
        uint256 manufactureDate;
        uint256 expiryDate;
        address manufacturer;
        address currentOwner;
        bool exists;
    }

    mapping(string => Batch) public batches;

    event BatchCreated(string batchId, address manufacturer);
    event OwnershipTransferred(string batchId, address from, address to);

    constructor(address _registry) {
        registry = ManufacturerRegistry(_registry);
    }

    modifier onlyRegisteredManufacturer() {
        require(registry.isRegistered(msg.sender), "Not registered manufacturer");
        _;
    }

    modifier onlyOwner(string memory batchId) {
        require(batches[batchId].currentOwner == msg.sender, "Not batch owner");
        _;
    }

    function createBatch(
        string memory batchId,
        string memory productName,
        uint256 manufactureDate,
        uint256 expiryDate
    ) public onlyRegisteredManufacturer {
        require(!batches[batchId].exists, "Batch already exists");

        batches[batchId] = Batch({
            batchId: batchId,
            productName: productName,
            manufactureDate: manufactureDate,
            expiryDate: expiryDate,
            manufacturer: msg.sender,
            currentOwner: msg.sender,
            exists: true
        });

        emit BatchCreated(batchId, msg.sender);
    }

    function transferOwnership(string memory batchId, address to)
        public
        onlyOwner(batchId)
    {
        batches[batchId].currentOwner = to;
        emit OwnershipTransferred(batchId, msg.sender, to);
    }

    function getBatch(string memory batchId)
        public
        view
        returns (Batch memory)
    {
        return batches[batchId];
    }
}
