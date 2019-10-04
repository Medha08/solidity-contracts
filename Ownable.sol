pragma solidity ^0.5.0;

contract Ownable {
  address payable public owner;

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address payable newOwner) public onlyOwner {
    require(newOwner != address(0));
    owner = newOwner;
  }

}
