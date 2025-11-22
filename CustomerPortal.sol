// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./SupplyChain.sol";

contract CustomerPortal {
    SupplyChain public supplyChain;

    constructor(address _supplyChain) {
        supplyChain = SupplyChain(_supplyChain);
    }

    function verifyDrug(string memory batchId)
        public
        view
        returns (
            string memory productName,
            address manufacturer,
            address currentOwner,
            bool isValid
        )
    {
        SupplyChain.Batch memory batch = supplyChain.getBatch(batchId);
        return (
            batch.productName,
            batch.manufacturer,
            batch.currentOwner,
            batch.exists
        );
    }
}
