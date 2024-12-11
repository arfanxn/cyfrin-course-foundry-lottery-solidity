// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;


import {VRFConsumerBaseV2Plus} from "@chainlink/contracts@1.1.1/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

/**
 * @title Raffle
 * @author Arfan
 * @notice A smart contract for a raffle
 */
contract Raffle {
    /* Errors */
    error Raffle__NotEnoughEth();

    /* State vars*/
    uint256 private immutable i_entraceFee;
    // @dev the duration of the lottery in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /* Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entraceFee, uint256 interval) {
        i_entraceFee = entraceFee;
        i_interval = interval;
    }

    //
    function enterRaffle() public payable {
        // require(msg.value >= i_entraceFee, "Not enough ETH sent!");
        if (msg.value < i_entraceFee) {
            revert Raffle__NotEnoughEth();
        }

        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external view {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }

        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                //
                keyHash: s_keyHash,
                subId: s_subcriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
    }

    function getEntranceFee() external view returns (uint256) {
        return i_entraceFee;
    }
}
