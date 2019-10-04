pragma solidity ^0.5.0;

contract Random{
    
    event RandomGenerate();
    
    uint randomNumber;
    
    function genNumber()public{
        emit RandomGenerate();
    }
    
    function setNumber(uint num)public{
        randomNumber = num;
    }
    
}
