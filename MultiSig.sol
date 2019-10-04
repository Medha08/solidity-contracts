pragma solidity ^0.5.0;

import "browser/Verification.sol";

contract MultiSig{

// web3 generate digest 
// Signature Verification - ecrecover 
// Multi Sig Wallet sig1 -> verify  sig2 -> verify -> state var change 
// State Channel open close challenge claim 

// open 
// p1 p2 -> eth 
//can not submit eth now


// close 
// state var value change 
//if all parameter such as nonce p1,p2 -> sig1 sig2  correct

//Web3 -> "nonce-p1-p2" eg. ("337") -> sign from p1 private key -> sig1
                          //("337") -> sign from p2 private key -> sig2
                          
//close(nonce,p1,p2,sig1,sig2) -> covert everything to string -> concat -> "337" -> hash("337") --> ecrecover(hash,sig1) == p1 && ecrecover(hash,sig2) == p2
    
    // take hash message and verify the signature from address is same as address given 
    // take the message and verify the second signature is also same 
    //change the mutiSig ste to 1 else 0 
    using Verification for bytes32 ;
    
    function verify(bytes32  _hashMessage, bytes memory  _signature1,bytes memory  _signature2, address _signer,address _signer2) public pure returns(address,address, bool){
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hashMessage));
        address addFromSig = prefixedHash.recover(_signature1);
        address addFromSig2 = prefixedHash.recover(_signature2);
        if(addFromSig == _signer && addFromSig2 == _signer2){
            return(addFromSig,addFromSig2,true);
        }else{
            return(addFromSig,addFromSig2,false);
        }
    }
}
