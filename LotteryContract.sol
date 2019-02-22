pragma solidity ^0.5.0;

contract Lottery{
    
    address payable [] public players;//dynamic array with player's address
    address public manager;//contract manager
    
    constructor()public{
        
        manager = msg.sender; // without setter for the state variable manager you cannot change the manager or value of manager variable 
        
    }
    
    enum State{ Start , Stop }
    
    State public status = State.Start;
    
    modifier ManagerCheck(){
         
         require(manager == msg.sender);
         
         _;
    }
    
    modifier StatusStart(){
        
        require(status == State.Start);
        
        _;
    }
    
    //fallback function will be automatically called when somebody sends some ether to contract's address
    function()external payable StatusStart {
        require(msg.value >= 0.01 ether);
        players.push(msg.sender);//add address of the account who send ether ie participate in the lottery adds their addr in players array 
    }
    
    function getbalance() public view ManagerCheck returns(uint){
        
        return address(this).balance;  //return contract balance
        
    }
    
    function random() public view  StatusStart returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp , players.length)));
    }
    
    function selectWinner()public view StatusStart returns(address){
        uint winnerIndex =  random()%players.length;
        return players[winnerIndex];
    }
    
    function transferAmount( address payable  winner ) payable public ManagerCheck StatusStart returns(bool){
        
        winner.transfer(address(this).balance);
        
       // players = new address payable [](3); //  I initalize dynamic array with size 3 first 3
                                              //elementnt  will be initialized as  0x0000 after 3 it will show error and
                                              //values in array will have to be added explicitly and size will increase as dynamic array 
        
        players = new address payable [](0); //resetting players dynamic array 
        changeStatus();
        return true;
        
    }
    
    function changeStatus() internal{
        status = State.Stop;
    }
    
    
}
