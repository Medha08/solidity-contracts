pragma solidity ^0.5.0;

import "browser/Verification.sol";
import "browser/SplitForm.sol";

contract StateChannel{
    
    using Verification for bytes32;
    using SplitForm for *;
    
    uint public valPlayer1 ;
    uint public valPlayer2;
    uint totalDeposited;
    address payable player1;
    address payable player2;
    enum State {Open,OffChain,Closed,Challenge,Claim}
    State playerState = State.Open;
    uint timeline;
    
    modifier checkState(uint expectedState,uint currentState){
        require(expectedState == currentState);
        _;
    }
    
    constructor(address payable _p1, address payable _p2)public {
        player1 = _p1;
        player2 = _p2;
    }
    
    function open()public payable checkState(0,uint(playerState)){
        if(msg.sender == player1)
            valPlayer1 = msg.value;
        else if(msg.sender == player2)
            valPlayer2 = msg.value;
            
        if(valPlayer1 != 0 && valPlayer2 != 0)    
            {
                playerState = State.OffChain;
                totalDeposited = valPlayer1 + valPlayer2;
            }

    }
    
    function verify(bytes32  _hashMessage, bytes memory  _signature1,bytes memory  _signature2, address _signer,address _signer2) public pure returns(bool){
    
        address addFromSig = _hashMessage.recover(_signature1);
        address addFromSig2 = _hashMessage.recover(_signature2);
        if(addFromSig == _signer && addFromSig2 == _signer2){
            return(true);
        }else{
            return(false);
        }
    }
    
    function closed(uint _nonce,uint _p1, uint _p2,bytes memory _signature1,bytes memory _signature2 )public checkState(1,uint(playerState)) returns(bool,bytes32){
        //split uint to individual values check if total under total depositied send hash message for verification set values and start challenge period
        require(_p1+_p2 <= totalDeposited);
        string memory hashStrMessage = SplitForm.append(SplitForm.uint2str(_nonce),SplitForm.uint2str(_p1),SplitForm.uint2str(_p2));
        bytes32 hashMessage = SplitForm.hash(hashStrMessage);
        if(verify(hashMessage,_signature1,_signature2,player1,player2) == true){
            valPlayer1 = _p1;
            valPlayer2 = _p2;
            timeline = now + 1 minutes;
             playerState = State.Challenge;
             return (true,hashMessage);
        }
        else{
            return (false,hashMessage);
        }
    }
    
    
    function challenge(uint _nonce,uint _p1, uint _p2,bytes memory _signature1,bytes memory _signature2 )public checkState(3,uint(playerState)) {
    
        require(_p1+_p2 <= totalDeposited && now < timeline + 1 minutes );
        string memory hashStrMessage = SplitForm.append(SplitForm.uint2str(_nonce),SplitForm.uint2str(_p1),SplitForm.uint2str(_p2));
        bytes32 hashMessage = SplitForm.hash(hashStrMessage);
        if(verify(hashMessage,_signature1,_signature2,player1,player2) == true){
            valPlayer1 = _p1;
            valPlayer2 = _p2;
        }

        
    }
    
    function claim() public returns(bool){
        if(now > timeline || playerState == State.Closed){
            player1.transfer(valPlayer1);
            player2.transfer(valPlayer2);
            playerState = State.Claim;
            return true;
        }
        else
          return false;
    }
    


}
