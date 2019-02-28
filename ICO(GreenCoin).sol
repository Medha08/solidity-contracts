pragma solidity ^0.5.0;

import "browser/GreenCoin.sol";

contract GreenCoinICO is GreenCoin{
    
    address public admin;
    address payable public deposit;
    
    // 1GRC = 1000000000000000 ETH :: 1 ETH  = 1000 GRC
    
    uint tokenPrice = 1000000000000000;
    
    
    //300 ether in wei
    uint public hardCap = 300000000000000000000;
    
    uint public raisedAmount;
    uint public salesStart = now;
    uint public salesEnd = now + 604800; // 1 week
    
    uint freeTokens = salesEnd + 604800; // transferrable in after a week of salesEnd
    
    uint public maxinvestment = 5000000000000000000;
    uint public minInvestment = 1000000000000000;
    
    enum State { beforeStart,running,afterEnd,halted}
    State public icoState;
    
    event Invest(address indexed_address,uint _value,uint _tokens);
    
    constructor(address payable _deposit)public{
        admin = msg.sender;
        deposit = _deposit;
        icoState = State.beforeStart;
    }
    
    
    modifier onlyAdmin(){
        require(admin == msg.sender);
        _;
    }
    
    //emergency stop
    function halt() public onlyAdmin{
         
        icoState = State.halted;
    }
    
    //beforeStart
    function unHalt() public onlyAdmin{
         
        icoState = State.running;
    }
    
    function changeDepositAddress(address payable _newDepositAddr)public onlyAdmin{
        deposit = _newDepositAddr;
    }
    
    function getState()public view  returns(State){
        if(icoState == State.halted){
            return State.halted;
        }else if(block.timestamp < salesStart){
            return State.beforeStart;
        }else if(block.timestamp >= salesStart && block.timestamp <= salesEnd){
            return State.running;
        }else{
            return State.afterEnd;
        }
    }
    
    function invest()public payable returns(bool){
        
        icoState = getState();
        require(icoState == State.running);
        require( msg.value >= minInvestment && msg.value  <= maxinvestment);
        
        uint tokensEquivalent = msg.value / tokenPrice;
        
        require(raisedAmount + msg.value <= hardCap );
    
        raisedAmount += msg.value;
        
        //add tokens to investor's balance from founder's balance
        balances[msg.sender] += tokensEquivalent;
        balances[founder] -= tokensEquivalent;
        
        deposit.transfer( msg.value );//good security practice
        
        emit Invest(msg.sender,msg.value, tokensEquivalent);
        return true;
        
    }
    
    function() external payable{ // if he sends ether directly to contract addr fallback function called
        invest(); 
    }
    
    function transfer(address _to,uint _tokens) public returns(bool ){
        require(block.timestamp > freeTokens);
        super.transfer(_to,_tokens);
    }
    
     function transferFrom(address _from,address _to,uint _tokens) public returns (bool){
        require(block.timestamp > freeTokens);
        super.transferFrom(_from,_to,_tokens);
     }
     
     function burn() public onlyAdmin{
         icoState = getState();
         require(icoState == State.afterEnd);
         balances[founder] =0;
     }
}
