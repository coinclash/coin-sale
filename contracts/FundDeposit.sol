// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FundDeposit {
    address owner;
    mapping (address => bool) private whiteListedUsers;
    mapping (address => uint) maxUserDeposit;
    mapping (address => uint) private userBalance;
    address constant USDT = 0xB0Dfaaa92e4F3667758F2A864D50F94E8aC7a56B; //USDT token address in Rinkeby network

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can access");
        _;
    }

    /// @notice only whitelisted users can deposit the funds
    fallback() external payable {
        require(whiteListedUsers[msg.sender], "user is not in whitelist");
        require(msg.value != 0 && (msg.value + userBalance[msg.sender]) <= maxUserDeposit[msg.sender], "amount should be more than zero and less than the reserved amount");
        userBalance[msg.sender] += msg.value;
    }

    function whiteListUser(address user, uint maxAmount) external onlyOwner {
        whiteListedUsers[user] = true;
        maxUserDeposit[user] = maxAmount;
    }

    function balance(address user) external view onlyOwner returns (uint) {
        return userBalance[user];
    }

    function withdraw() external onlyOwner {
        if(address(this).balance != 0){
            (bool success, ) = payable(owner).call{value: address(this).balance}("");
            require(success, "withdrawal failed");
        }
        uint usdtBalance = IERC20(USDT).balanceOf(address(this));
        if(usdtBalance != 0){
            bool success = IERC20(USDT).transfer(owner, usdtBalance);
            require(success, "USDT withdrawal failed");
        }
    }
}