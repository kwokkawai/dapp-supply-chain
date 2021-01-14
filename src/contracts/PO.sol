pragma solidity ^0.5.0;
import "./DateTime.sol";

contract PO is DateTime {
    
  uint32 public POID;    
  poline[] public POLine;
  address public IssueFrom;
  address public IssueTo;
  uint256 public IssueDue;
  uint256 public Expiry;
  POSTATUS public POStatus;
  signature[] public POTrail; 
  
  struct poline {
      
      uint32 POID;
      string assetName;
      uint32 requestQty;
      uint32 unitPrice;
      uint256 requestTime;
  }
 
 struct signature {
     string what;
     address whofrom;
     address whoto;
     uint256 when;
 }
 
 enum POSTATUS {
     DRAFT,
     SIGNED,
     ISSUED,
     CONFIRMED,
     RECEIPT,
     INVOICED,
     SETTLED,
     CANCELLED
 }

  constructor(uint32 _POID, address _IssueFrom, address _IssueTo, uint32 _IssueDue, uint32 _Expiry, string memory _assetName, uint32 _requestQty, uint32 _unitPrice, uint32 _requestTime) public {
  
    POID = _POID;    
    IssueFrom = _IssueFrom;
    IssueTo = _IssueTo;
    IssueDue = _IssueDue;
    Expiry = _Expiry;
    POStatus = POSTATUS.DRAFT;
    poline memory newPOline = poline(_POID, _assetName, _requestQty, _unitPrice, _requestTime);
    POLine.push(newPOline);
    
  }
  
  function purchase(address _to, uint32 _IssueDue, uint32 _Expiry) public {
    require(msg.sender == IssueFrom);
    require(_to != IssueFrom);
    require(POStatus == POSTATUS.SIGNED);

    IssueTo = _to;
    IssueDue = _IssueDue;
    Expiry = _Expiry;
    POStatus = POSTATUS.ISSUED;
    signature memory newPOTrail = signature("PO ISSUED", msg.sender, _to, now);
    POTrail.push(newPOTrail);   
  }
  
  function sign() public {      
    require(POStatus == POSTATUS.DRAFT); 
 
    POStatus = POSTATUS.SIGNED;
    signature memory newPOTrail = signature("PO SIGNED", msg.sender, msg.sender, now);
    POTrail.push(newPOTrail);
  }
}