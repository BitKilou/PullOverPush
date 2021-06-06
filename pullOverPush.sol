// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
pragma abicoder v2;

///@title Training Pull over pullOverPush
///@author Kilian Mongey
///@dev This is just a training do not use for safety reasons

import "@openzeppelin/contracts/access/Ownable.sol";

contract pullOverPush is Ownable {
    
    uint public value;
    
    ///@dev deploying our contract, putting a bit of ETH inside it
    
    constructor() payable{
        
    }
    
    event whiteListedToPull(address isAllowedToWithdraw, uint amountAllowedToWithdraw);
    event hasWithdrawn(address thisAddressHasWithdrawn);
    
    ///@dev simple mapping to query users funds

    mapping(address => uint) tokenToClaim;
    
    ///@dev here the owner will be able to give permission to users to pull there funds

    function allowUsersToPull(address _receiver, uint _amount) public payable onlyOwner {
       
       tokenToClaim[_receiver] += _amount;
       
       emit whiteListedToPull(_receiver, _amount);

    }
    
    ///@dev the users will be able to pull their funds from this function
    ///@dev we require 2 things, the contract address != 0 and contract balance > amount to withdraw
    ///@dev we then put the token to claim amount to 0 

    function pullTokens() public payable {

        uint _amount = tokenToClaim[msg.sender];

        require(_amount != 0, "the amount is equal to 0");
        require(address(this).balance >= _amount);

        tokenToClaim[msg.sender] = 0;

        payable(msg.sender).transfer(_amount);
        
        emit hasWithdrawn(msg.sender);

    }
    
    ///@dev below are two helping functions for devs to keep track of state;
    
    function getBalance(address _address) public view returns(uint) {
        return tokenToClaim[_address];
    }
    
    function getBalanceOfThis() public view returns(uint) {
        return address(this).balance;
    }
}