pragma solidity ^0.5.0;
import "./DateTime.sol";

contract BuyerInvoice is DateTime {
    
  uint32 public INVID;    
  invline[] public INVLine;
  address public IssueFrom;
  address public IssueTo;
  uint256 public IssueDue;
  uint256 public Expiry;
  BINVSTATUS public BINVStatus;
  signature[] public BINVTrail; 
  
  struct invline {
      
      uint32 INVID;
      string assetName;
      uint32 INVQty;
      uint32 unitPrice;
      string remark;
      uint256 paymentTime;
      string paymentTerm;
  }
 
  struct signature {
     string what;
     address whofrom;
     address whoto;
     uint256 when;
  }
 
 enum BINVSTATUS {
     DRAFT,
     SIGNED,
     ISSUED,
     CONFIRMED,
     RECEIPT,
     INVOICED,
     SETTLED,
     CANCELLED
 }

  constructor(uint32 _INVID, address _IssueFrom, address _IssueTo, uint256 _IssueDue, uint256 _Expiry, string memory _assetName, uint32 _INVQty, uint32 _unitPrice, string memory _remark, uint256 _paymentDate, string memory _paymentTerm) public {
  
    INVID = _INVID;    
    IssueFrom = _IssueFrom;
    IssueTo = _IssueTo;
    IssueDue = _IssueDue;
    Expiry = _Expiry;
    BINVStatus = BINVSTATUS.DRAFT;
    invline memory newINVline = invline(_INVID, _assetName, _INVQty, _unitPrice, _remark, _paymentDate, _paymentTerm);
    INVLine.push(newINVline);
    
  }
  
  function selfbill(address _to, uint32 _IssueDue, uint32 _Expiry) public {
    require(msg.sender == IssueFrom);
    require(_to != IssueFrom);
    require(BINVStatus == BINVSTATUS.SIGNED);

    IssueTo = _to;
    IssueDue = _IssueDue;
    Expiry = _Expiry;
    BINVStatus = BINVSTATUS.ISSUED;
    signature memory newBINVTrail = signature("Buyer Invoice ISSUED", msg.sender, _to, now);
    BINVTrail.push(newBINVTrail);   
  }
  
  function sign() public {      
    require(BINVStatus == BINVSTATUS.DRAFT); 
 
    BINVStatus = BINVSTATUS.SIGNED;
    signature memory newBINVTrail = signature("Buyer Invoice SIGNED", msg.sender, msg.sender, now);
    BINVTrail.push(newBINVTrail);
  }
}