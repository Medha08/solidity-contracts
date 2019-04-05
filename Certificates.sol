pragma solidity ^0.5.0;

contract Certificate{
    
    
    
    
    address  payable public owner;
    
    string public leftName;
    string public rightName;
    string public leftVows;
    string public rightVows;
    
    modifier _onlyOwmer(){
        
        require(msg.sender == owner);
        
        _;
    }
    
    constructor(address payable _owner , string memory _leftName, string memory _rightName , string memory _leftVows , string memory _rightVows ) public {
        leftName = _leftName;
        rightName = _rightName;
        leftVows = _leftVows;
        rightVows = _rightVows;
        
        owner = _owner;
        
    }
    
    function  ringBell() payable public {
        require(msg.value > 0.001 ether);
    }
    
    function collect()  external _onlyOwmer {
       owner.transfer(address(this).balance);
       
    }
    
    function getBalance() public view _onlyOwmer returns(uint){
        return address(this).balance;
    }
}

contract CertificateFactory{
    
    event ContractCreated(address certi);
    
    address[] public registeredPromises ;
    
    function createPromise(string memory _leftName, string memory _rightName , string memory _leftVows , string memory _rightVows) public {
        
        address certi = address(new Certificate(msg.sender, _leftName,_rightName ,_leftVows , _rightVows));
        emit ContractCreated(certi);
        registeredPromises.push(certi);
       
        
    }
}