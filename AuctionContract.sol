k.number <= endBlock);
        _;
    }
    
    function min(uint _a, uint _b)internal pure returns(uint){
        if(_a > _b){
            return _b;
        }else{
            return _a;
        }
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    function cancelAuction()public{
        auctionState = State.Cancelled;
    }
    
    function placeBid()public payable afterStart beforeEnd notOwner returns(bool){
        require(msg.value >= 0.01 ether); 
        
        uint currentBid = bids[msg.sender] + msg.value;
        bids[msg.sender] = currentBid;
        
        require(currentBid >= highestBidingBid);
        
        if(currentBid >= bids[highestBidder]){
            highestBidingBid = min(currentBid,bids[highestBidder]+bidIncrement);
            highestBidder = msg.sender;
        }else{
            highestBidingBid = min(currentBid+bidIncrement,bids[highestBidder]);
        }
        
        return true;
        
    }
    
    function finalizeAuction()public{
        require(auctionState == State.Cancelled || block.number > endBlock);//auction has been cancelled
        
        require(bids[msg.sender]>0 || msg.sender == owner);
        
        address payable recipient;
        uint value;
        
        if(auctionState == State.Cancelled){
            recipient = msg.sender;
            value = bids[msg.sender];
        }else{//ended not cancelled
            if(msg.sender == owner){
                recipient = owner;
                value = highestBidingBid;
            }else{
                if(msg.sender == highestBidder){
                    recipient = highestBidder;
                    value = bids[highestBidder]-highestBidingBid;
                }else{//this is not the highest bidder or owner
                    recipient = msg.sender;
                    value = bids[msg.sender];
                }
            }
            
        }
        recipient.transfer(value);
    }
}
