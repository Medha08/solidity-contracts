pragma solidity ^0.5.0;

library SplitForm{
    
function bytes32ToString (bytes32  data) public pure returns (string memory) {
    bytes memory bytesString = new bytes(32);
    for (uint j=0; j<32; j++) {
        byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[j] = char;
        }
    }
    return string(bytesString);
}

function uint2str(uint _i) public pure returns (string memory _uintAsString) {
    if (_i == 0) {
        return "0";
    }
    uint j = _i;
    uint len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (_i != 0) {
        bstr[k--] = byte(uint8(48 + _i % 10));
        _i /= 10;
    }
    return string(bstr);
 }
 
 function append(string memory a, string memory b, string memory c) public pure returns (string memory) {

    return string(abi.encodePacked(a, b, c));

}

function stringToBytes32(string memory source) public pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
        return 0x0;
    }

    assembly {
        result := mload(add(source, 32))
    }
}
 function hash(string memory message) public pure returns(bytes32){
    
        string memory header = "\x19Ethereum Signed Message:\n000000";
    
        uint256 lengthOffset;
        uint256 length;
        assembly {
          // The first word of a string is its length
          length := mload(message)
    
          // The beginning of the base-10 message length in the prefix
          lengthOffset := add(header, 57)
        }
    
        // Maximum length we support
        require(length <= 999999);
    
        // The length of the message's length in base-10
        uint256 lengthLength = 0;
    
        // The divisor to get the next left-most message length digit
        uint256 divisor = 100000;
    
        // Move one digit of the message length to the right at a time
        while (divisor != 0) {
    
          // The place value at the divisor
          uint256 digit = length / divisor;
    
          if (digit == 0) {
            // Skip leading zeros
            if (lengthLength == 0) {
              divisor /= 10;
              continue;
            }
          }
    
          // Found a non-zero digit or non-leading zero digit
          lengthLength++;
    
          // Remove this digit from the message length's current value
          length -= digit * divisor;
    
          // Shift our base-10 divisor over
          divisor /= 10;
          
          // Convert the digit to its ASCII representation (man ascii)
          digit += 0x30;
    
          // Move to the next character and write the digit
          lengthOffset++;
          assembly {
            mstore8(lengthOffset, digit)
          }
        }
    
        // The null string requires exactly 1 zero (unskip 1 leading 0)
        if (lengthLength == 0) {
          lengthLength = 1 + 0x19 + 1;
    
        } else {
          lengthLength += 1 + 0x19;
        }
    
        // Truncate the tailing zeros from the header
        assembly {
          mstore(header, lengthLength)
        }
    
        // Perform the elliptic curve recover operation
        bytes32 check = keccak256(abi.encodePacked(header, message));
        return check;
    }
}