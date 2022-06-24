// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FundWithdraw {
    address owner;
    mapping (address => bool) private whiteListedUsers;
    mapping (address => uint) userDepositBlockNumber;
    mapping (address => bool) adminAccess;
    address constant USDT = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709; //cahinlink token change it in final build.


    constructor() {
        owner = msg.sender;
    }

    fallback() external payable {  //check it later
        require(msg.sender == owner, "only owner can deposit funds");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can access");
        _;
    }

    modifier onlyAdmin() {
        require(adminAccess[msg.sender], "only Admins can access");
        _;
    }

    function withdraw(address userAddress, uint amount) external onlyAdmin returns (bool){
        require(whiteListedUsers[userAddress], "User is not in the whitelist");
        require(address(this).balance >= amount, "Insufficient funds in the contract");
        require(block.number - userDepositBlockNumber[userAddress] > 4, "user cannot  withdraw funds now"); //change 4 to 250
        userDepositBlockNumber[userAddress] = block.number;

        (bool success, ) = (userAddress).call{value: amount}("");
        require(success, "Withdrawal failed");
        return success;
    }

    function deposit() external payable {
        require(whiteListedUsers[msg.sender], "user is not in the whitelist");
        require(msg.value > 0, "Cannot deposit 0 ETH");

    }

    function depositUSDT(uint amount) external  {
        require(amount>0, "Cannot deposit 0 USDT");
        require(whiteListedUsers[msg.sender], "user is not the whitelist");
        require(IERC20(USDT).allowance(msg.sender, address(this)) >= amount, "User didn't approve the USDT transfer");
        bool success = IERC20(USDT).transferFrom(msg.sender, address(this), amount);
        require(success, "USDT Deposit failed");

    }

    function whiteListUser(address userAddress) external onlyAdmin {
        if(whiteListedUsers[userAddress]){
            whiteListedUsers[userAddress]= false;
        }
        else {
            whiteListedUsers[userAddress] = true;
        }
    }

    function contractBalance() external view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function contractUSDTBalance() external view onlyOwner returns (uint) {
        return IERC20(USDT).balanceOf(address(this));
    }

    function enableAdminAccess(address userAddress) external onlyOwner {
        adminAccess[userAddress] = true;
    }

    ///@notice only owner can withdraw funds
    function withdrawFunds() external onlyOwner {
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