pragma solidity ^0.5.0;

import "browser/UdemyAuction.sol";

contract UdemyAuctionCreator{
    
    address public owner;
    address[] public deployedContracts;
    
    constructor()public{
        owner = msg.sender;
    }
    
    function createNewAuction()public returns(bool){
        UdemyAuction newAuction = new UdemyAuction(msg.sender);
        deployedContracts.push(address(newAuction));
        return true;
    }
}
