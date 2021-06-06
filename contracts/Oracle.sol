// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Oracle {
    struct Data {
        uint256 date;
        uint256 payload;
    }

    address public admin;
    mapping(address => bool) public reporters;
    mapping(bytes32 => Data) public data;

    constructor(address _admin) {
        admin = _admin;
    }

    function updateReporter(address _reporter, bool isReporter) external {
        require(msg.sender == admin, "Only Admin");
        reporters[_reporter] = isReporter;
    }

    function updateData(bytes32 key, uint256 payload) external {
        require(reporters[msg.sender] == true, "Only Reporter");
        data[key] = Data(block.timestamp, payload);
    }

    function getData(bytes32 key)
        external
        view
        returns (
            bool result,
            uint256 date,
            uint256 payload
        )
    {
        if (data[key].date == 0) {
            return (false, 0, 0);
        }
        return (true, data[key].date, data[key].payload);
    }
}
