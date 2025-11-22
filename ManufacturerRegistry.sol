// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ManufacturerRegistry {
    address public owner;
    uint256 public registrationFee;

    struct Manufacturer {
        string name;
        bool registered;
        uint256 registeredAt;
    }

    mapping(address => Manufacturer) public manufacturers;

    event ManufacturerRegistered(address indexed manufacturer, string name);
    event RegistrationFeeChanged(uint256 oldFee, uint256 newFee);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    constructor(uint256 _fee) {
        owner = msg.sender;
        registrationFee = _fee;
    }

    function registerManufacturer(string calldata _name) external payable {
        require(!manufacturers[msg.sender].registered, "Already registered");
        require(msg.value >= registrationFee, "Insufficient fee");

        manufacturers[msg.sender] = Manufacturer({
            name: _name,
            registered: true,
            registeredAt: block.timestamp
        });

        emit ManufacturerRegistered(msg.sender, _name);
    }

    function isRegistered(address manufacturer) external view returns (bool) {
        return manufacturers[manufacturer].registered;
    }

    function setRegistrationFee(uint256 newFee) external onlyOwner {
        uint256 old = registrationFee;
        registrationFee = newFee;
        emit RegistrationFeeChanged(old, newFee);
    }
}
