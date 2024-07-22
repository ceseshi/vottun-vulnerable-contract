// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract VulnBank {
    mapping(address => uint256) balances;

    // Deposits ether
    function deposit() public payable {
        _setBalance(msg.sender, balances[msg.sender] + msg.value);
    }

    // Returns the ether
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient user balance");
        require(address(this).balance >= amount, "Insufficient contract balance");

        _setBalance(msg.sender, balances[msg.sender] - amount);

        (bool success,) = msg.sender.call{value: amount}("");

        require(success, "Failed to return Ether");
    }

    // This is vulnerable!! should be internal/private
    function _setBalance(address account, uint256 newBalance) public {
        balances[account] = newBalance;
    }
}
