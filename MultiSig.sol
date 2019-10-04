pragma solidity ^0.5.0;

import "browser/Verification.sol";

contract MultiSig{
    
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
