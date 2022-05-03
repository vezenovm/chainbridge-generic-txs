// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract BridgeFungibleToken is ERC20 {

    address private _sourceDepositer;
    address private _destinationHandler;

    event TxsExecuted(address indexed initiatorExecution, bytes[] returnedData);

    constructor(address sourceDepositer, address destinationHandler) ERC20("Dummy", "DERC20") {
        _sourceDepositer = sourceDepositer; 
        _destinationHandler = destinationHandler;
        // _mint(msg.sender, initialSupply);
    }

    modifier onlyDestinationHandler() {
        require(msg.sender == _destinationHandler, 'unauthorized destination handler');
        _;
    }

    /**
        The depositer offset will be specified in the calldata passed to the generic handler
    */
    function processMessageFromHandler(
        bytes32 resourceID,
        address depositer,
        bytes calldata data
    ) external payable onlyDestinationHandler {
        require(_sourceDepositer == depositer, 'incorrect depositer in the data');

        (address _toAddress, uint256 _amount) = abi.decode(data, (address, uint256));

        _mint(_toAddress, _amount);
    }

    receive() external payable {}

    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}