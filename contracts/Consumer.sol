// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IOracle.sol";

contract Consumer {
    IOracle public oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function foo() external {
        bytes32 key = keccak256(abi.encodePacked("SOL/USD"));
        (bool result, uint256 date, uint256 payload) = oracle.getData(key);
        require(result == true, "could not get price");
        require(date <= block.timestamp - 2 minutes, "date too old");
        // do somthing with price
    }
}
