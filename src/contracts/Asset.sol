pragma solidity ^0.5.0;

contract Asset {
  uint32 public assetID;
  string public assetName;
  uint32 public assetValue;
  string public assetAttr1;
  string public assetAttr2;
  address public assetOwner;
  address[] public assetTrail;
  ASTATUS public assetStatus;

  enum ASTATUS {
    CREATED,
    INTRANSIT,
    INSTOCK,
    OBSOLETE,
    EOL
  }

  event Action(
    string name,
    address account,
    address custodian,
    uint timestamp
  );
  
  constructor(uint32 _assetID, string memory _assetName, uint32 _assetValue, string memory _assetAttr1, string memory _assetAttr2) public {
  
    assetID = _assetID;
    assetName = _assetName;
    assetValue = _assetValue;
    assetAttr1 = _assetAttr1;
    assetAttr2 = _assetAttr2;  
    assetOwner = msg.sender;
    assetTrail.push(msg.sender);
    assetStatus = ASTATUS.CREATED;
  }

  function getAsset() public returns(uint32, string memory, uint32, string memory, string memory, address) {
      return(assetID, assetName, assetValue, assetAttr1, assetAttr2, assetOwner);
  }
  
  function ship(address _to) public {
    // Must be custodian to send
    require(msg.sender == assetOwner);
    require(_to != assetOwner);
    require(assetStatus != ASTATUS.INTRANSIT);
    require(assetStatus != ASTATUS.EOL);
    
    // Update Attribute
    assetStatus = ASTATUS.INTRANSIT;
    assetOwner = _to;

    // Log history
    emit Action("ship", msg.sender, _to, now);
  }

  function receipt() public {

    require(msg.sender == assetOwner);
    require(assetStatus == ASTATUS.INTRANSIT);

    // Update Attribute
    assetStatus = ASTATUS.INSTOCK;
    assetTrail.push(assetOwner);
    
    // Log history
    emit Action("receipt", msg.sender, msg.sender, now);
  }


}