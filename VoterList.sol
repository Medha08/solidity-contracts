pragma solidity ^0.5.0;

import "browser/User.sol";

contract VoterList is User {
    address[] public regVoters;
    mapping(address => address) citizenToCitizenCont;
    
   function getAllVoters() public view onlyECIAccess(msg.sender) returns (address[] memory){
       address [] memory voters;
       for(uint i =0;i< regVoters.length;i++){
            voters[i] = regVoters[i];
        }
        return voters;
   }
   
   function registerVoter()public{
       regVoters.push(msg.sender);
   }
   
   function getContractAdd() public view onlyECIAccess(msg.sender) returns (address[] memory){
        address [] memory votersContr;
       for(uint i =0;i< regVoters.length;i++){
            votersContr[i] = citizenToCitizenCont[regVoters[i]] ;
        }
        return votersContr;
   }
   
   function getuserdetails() public view onlyECIAccess(msg.sender)  returns ( string memory , string memory , uint8  , bytes32  , address){
     User contractUser = User(citizenToCitizenCont[msg.sender]);
         return contractUser.getDetails();
   }
   
   function isRegistered() public view onlyECIAccess(msg.sender) returns(bool){
        for(uint i =0;i< regVoters.length;i++){
           if(regVoters[i] == msg.sender){
            return true;   
           }else{
               return false;
           }
        }
   }
}
