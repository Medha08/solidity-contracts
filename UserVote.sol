pragma solidity ^0.5.0;


contract User {
    
    address user;
    
    string name;
    string addressRes;
    uint8 age;
    bytes2 gender;
    address   voteGiven;
    address[] givenAccess;
    address [] public ECIMembers;
    mapping(address => bool) public ECIAccess; 
    mapping(address => bool) public accessToExpire;
    
    
    constructor() public{
        user = msg.sender;
    }
    
    modifier onlyECIAccess (address _addr) {
        require(ECIAccess[_addr]== true);
        _;
    }
    
    
 function getDetails() public view returns ( string memory , string memory , uint8  , bytes32  , address ){
     require(msg.sender == user || accessToExpire[msg.sender] == true || ECIAccess[msg.sender] ==  true );
     return (name,addressRes,age,gender,voteGiven);
 }

function giveAccess(address _addr, bool _expiry)public   returns(bool){
    accessToExpire[_addr] = _expiry;
} 

function setVoteGiven(address _candidate) public{
    voteGiven =_candidate;
}
    
function getVoteGiven() view public returns(address){
    require(msg.sender == user || accessToExpire[msg.sender] == true || ECIAccess[msg.sender] ==  true );
    return voteGiven;
}
    
}
