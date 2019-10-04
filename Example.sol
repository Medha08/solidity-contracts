pragma solidity ^0.5.0;

contract BabiesWithoutBorders{

    
     struct childReqStruc {
         uint pairId;
         uint paAge;
         uint medCond;
         uint gen;
         uint docVeri;

     }
     
     struct parentReqStruc{
         uint pairId;
         uint marStatus;
         uint net;
         uint ageComb;
         uint docVeri;
         uint yrsMar;
     }
     
     event FoundMatchParent(address indexed parent, int indexed pairIdPar, int fetchIdPar  );
     event FoundMatchChild(address indexed child, int indexed pairIdChil, int fetchIdChil  );
     event NotFound(address indexed sender, string indexed message);
     
     uint[] public childrenAgen;
     uint[] public parentAgen;
     
     childReqStruc[] public chilrenReq; 
     parentReqStruc[] public parentRequ; 
     
     mapping(uint => address) childToFetchAddAgent;
     mapping(address => uint) agentChildCount;
     mapping(uint => address) parentToFetchAddAgent;
     
      parentReqStruc[] public agentChildAdoptCount;
     childReqStruc[] public agentParentAdoptCount;
     
     uint idDigits = 8;
     uint idMod = 10 ** idDigits; 
     
     modifier yrsMarriage(uint yearsMar){
        require(yearsMar >= 2);
         _;
     }
     
    modifier agencies(address _caller){
        require(msg.sender == _caller );
        _;
    }
    
    function createId(uint age, uint medCond, uint gen , uint docVeri ) public returns(uint ){ // only agencies
        require(docVeri == 1);
        
        uint rand = uint ( keccak256(abi.encodePacked( age, medCond, gen ,docVeri )));
        rand = rand % idMod;
        
        childReqStruc memory newChildReq = childReqStruc(rand,age, medCond, gen ,docVeri );
         chilrenReq.push(newChildReq);

        uint id = childrenAgen.push(rand)-1;
        childToFetchAddAgent[id] = msg.sender;
        
        agentChildCount[msg.sender]++;
        return rand;
    }
    
    
    function createParentId(uint marStatus, uint net , uint ageComb , uint docVeri, uint yrsMar) public yrsMarriage(yrsMar) returns (uint)
    {   require(docVeri == 1);
        uint rand = uint ( keccak256(abi.encodePacked( marStatus, net, ageComb ,docVeri, yrsMar)));
        rand = rand % idMod;
        parentReqStruc memory newParentReq = parentReqStruc( rand,marStatus, net, ageComb ,docVeri, yrsMar);
        parentRequ.push(newParentReq);
       
        parentAgen.push(rand);
        return rand;
    }
    
    function parentReq(uint age, uint medCond, uint gen , uint docVeri )  public { 
        uint parentReqId = uint ( keccak256(abi.encodePacked(age,medCond, gen ,docVeri))) % idMod;
        uint i=0;
        for ( i = 0; i< childrenAgen.length ; i ++){
            if(childrenAgen[i] == parentReqId ){
             agentParentAdoptCount.push(chilrenReq[i]);
                //parentRequ[i].adopMatch = 1;
                emit FoundMatchParent (msg.sender,int(childrenAgen[i]),int(i)); 
            }
        }
        if(i == childrenAgen.length ){
             emit NotFound(msg.sender,"NotFound");
        }
        
    }
    
    
    function childReq(uint marStatus, uint net , uint ageComb , uint docVeri, uint yrsMar)  public {
        uint childReqId = uint ( keccak256(abi.encodePacked( marStatus, net, ageComb ,docVeri, yrsMar))) % idMod;
        uint i =0  ;
         for (i = 0; i< parentAgen.length ; i ++){
            if(parentAgen[i] == childReqId){
              
             agentChildAdoptCount.push(parentRequ[i]);
                emit FoundMatchChild (msg.sender,int(childrenAgen[i]),int(i)); 
            }
        }
        if(i == parentAgen.length){
             emit NotFound(msg.sender,"NotFound");
        }
    }
    
    
    function returnChildren()public view returns (uint[] memory){
        uint i = 0;
        uint[] memory returnArray;
        for(i=0;i< agentParentAdoptCount.length;i++){
            returnArray[i] = agentParentAdoptCount[i].pairId;
        }
        
       return  returnArray;
    }
  
    
    address[] public childAdoptions;
    function matchContract(uint childfetchId, uint parentFetchId) public{
        address parent = childToFetchAddAgent[childfetchId];
        address childAgency = parentToFetchAddAgent[parentFetchId];
        address newContract = address(new childContract(parent,childAgency,chilrenReq[childfetchId].pairId,parentRequ[parentFetchId].pairId));
        childAdoptions.push(newContract);
        
    }
}
  
//4,0,0,1
//1,10,40,1,4


contract childContract {
    
    struct childStatus{
        address parent;
        address childAgency;
        uint parentId;
        uint childId;
    }
    childStatus newChild;
    

    
    enum  State { ActiveAdoption , AgencyVerification , Government , AgencyVerification2 , Government2 , DeactivateAdoption} 

    State public childState;
    
    modifier checkState(uint state1,uint state2){
        require(state1 == state2);
        _;
    }
    
    modifier checkAddAgen1(address caller){
        require(caller == newChild.childAgency);
        _;
    }
    


    
    constructor  (address parent,address childAgency, uint parentId , uint childId) public{
       newChild = childStatus(parent,childAgency,parentId,childId);
       childState = State.ActiveAdoption ;
       
    }
    
    function AgencyVerificationChi()public checkState(uint(childState),0) {
        childState = State.AgencyVerification ;
    }
    
    function Government()public checkState(uint(childState),1){
        childState = State.Government ;
    }
    
    function AgencyVerificationPare () public checkState(uint(childState),2){
        childState = State.AgencyVerification2 ;
    }
    
    function Government2 () public checkState(uint(childState),3){
        childState = State.Government2 ;
    }
    
    function DeactivateAdoption () public checkState(uint(childState),4){
        childState = State.DeactivateAdoption ;
    }
    
    
}
