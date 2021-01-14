pragma solidity ^0.5.0;
import "./DateTime.sol";
import "./Asset.sol";
import "./PO.sol";
import "./BuyerInvoice.sol";

contract Supplychain {
    
    string public contract_name = "DAPP Supply Chain";
    string public version = "v0.1";
    uint32 public assetID;
    
    mapping(address => PO[]) public allPO;
    mapping(address => Asset[]) public allAsset;
    mapping(address => BuyerInvoice[]) public allBuyerInvoice;
    
    function createAsset(uint32 _assetID, string memory _assetName, uint32 _assetValue, string memory _assetAttr1, string memory _assetAttr2) public {

        Asset newAsset;
        newAsset = new Asset(_assetID, _assetName,_assetValue, _assetAttr1, _assetAttr2);
        allAsset[msg.sender].push(newAsset);   
    
    }
    
    function getAsset(address _address, uint32 index) public returns (uint32 _assetID, string memory _assetName, uint32 _assetValue, string memory _assetAttr1, string memory _assetAttr2, address _owneraddress) {
        
        (_assetID, _assetName, _assetValue, _assetAttr1, _assetAttr2, _owneraddress) = allAsset[msg.sender][index].getAsset();
        
        assetID = _assetID;
    }
}