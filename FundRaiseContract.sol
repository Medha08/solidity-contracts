pragma solidity ^0.5.0;

contract FundRaise{
    
    mapping(address => uint)public contributors;
    address public admin;
    
    uint public goal;
    uint public deadline; //timestamp in seconds
    uint public noOfContributors;
    uint public minContribution;
    
    uint public raisedAmount;
    
    
    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voting;
    }
    
    Request[] public requests;
    
    
    constructor(uint _goal, uint _deadline )public{
        admin = msg.sender;
        minContribution = 10;
        
        deadline = now + _deadline;
        goal = _goal;
    }
    
    modifier inFundTime(){
        require(now<deadline);
        _;
    }
    
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    
    event ContributeEvent(address sender,uint value);
    event CreateRequestEvent(string description,address recipient,uint value);
    event ProceedPay(address recipient,uint value);
    
    
    function contribute()public payable inFundTime returns(bool){
        require(now< deadline);
        require(msg.value >= minContribution);
        
        if(contributors[msg.sender] == 0)
        {
            noOfContributors++;
        }
            
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
        
        emit ContributeEvent(msg.sender,msg.value);
    }
    
    function getBalanc()public view  returns(uint){
        return address(this).balance;
    }
    
    function getRefund()public {
        require(now > deadline);
        require(raisedAmount < goal);
        require(contributors[msg.sender] > 0);
        
        address payable recipient = msg.sender;
        uint value = contributors[msg.sender];
        
        recipient.transfer(value);
        contributors[msg.sender] = 0;
    }
    
    function createRequest(string memory _desc,address payable _recpt,uint _val) public onlyAdmin {
        Request memory newRequest = Request({
                description:_desc,
                recipient:_recpt,
                value:_val,
                completed:false,
                noOfVoters:0
                });
                
                requests.push(newRequest);
                
                emit CreateRequestEvent(_desc,_recpt,_val);
    }
    
    function voting(uint index)public{
        Request storage calledReq = requests[index];
        
        
        require(contributors[msg.sender]>0);
        require(calledReq.voting[msg.sender] == false);
        
        calledReq.noOfVoters++;
        calledReq.voting[msg.sender] = true;
    }
    
    function proceedPay(uint index)public onlyAdmin{
        Request storage calledReq = requests[index];
        
        require(calledReq.completed == false);
        
        require(calledReq.noOfVoters >= (noOfContributors/2));
        
        calledReq.recipient.transfer(calledReq.value);
        calledReq.completed = true;
        
        emit ProceedPay(calledReq.recipient,calledReq.value);
           
    }
    
    
}
