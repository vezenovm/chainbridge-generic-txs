// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract BridgeExecutor {

    address private _sourceDepositer;
    address private _destinationHandler;

    event TxsExecuted(address indexed initiatorExecution, bytes[] returnedData);

    constructor(address sourceDepositer, address destinationHandler) {
        _sourceDepositer = sourceDepositer;
        _destinationHandler = destinationHandler;
    }

    function _executeTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'NOT_ENOUGH_CONTRACT_BALANCE');

        bytes memory callData;
        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodeWithSignature(signature, data);
        }

        bool success;
        bytes memory resultData;
        
        // solium-disable-next-line security/no-call-value
        (success, resultData) = target.call{value: value}(callData);
    
        return _verifyCallResult(success, resultData);
    }

    modifier onlyDestinationHandler() {
        require(msg.sender == _destinationHandler, 'unauthorized destination handler');
        _;
    }

    function execute(bytes calldata data) public payable {
        address[] memory targets;
        uint256[] memory values;
        string[] memory signatures;
        bytes[] memory calldatas;
        bool[] memory withDelegatecalls;

        (targets, values, signatures, calldatas, withDelegatecalls) = abi.decode(
        data,
        (address[], uint256[], string[], bytes[], bool[])
        );

        require(targets.length != 0, 'INVALID_EMPTY_TARGETS');
        require(
            targets.length == values.length &&
            targets.length == signatures.length &&
            targets.length == calldatas.length &&
            targets.length == withDelegatecalls.length,
            'INCONSISTENT_PARAMS_LENGTH'
        );

        uint256 numTxs = targets.length;

        bytes[] memory returnedData = new bytes[](numTxs);
        for (uint256 i = 0; i < numTxs; i++) {
            returnedData[i] = _executeTransaction(
                targets[i],
                values[i],
                signatures[i],
                calldatas[i]
            );
        }
        emit TxsExecuted(msg.sender, returnedData);
    }

    /**
        The depositer offset will be 
    */
    function processMessageFromHandler(
        bytes32 resourceID,
        address depositer,
        bytes calldata data
    ) external payable onlyDestinationHandler {
        require(_sourceDepositer == depositer, 'incorrect depositer in the data');

        execute(data);
    }

    function _verifyCallResult(bool success, bytes memory returndata)
        private
        pure
        returns (bytes memory)
    {
        if (success) {
        return returndata;
        } else {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly

            // solhint-disable-next-line no-inline-assembly
            assembly {
            let returndata_size := mload(returndata)
            revert(add(32, returndata), returndata_size)
            }
        } else {
            revert('FAILED_ACTION_EXECUTION');
        }
        }
    }

    receive() external payable {}

    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}