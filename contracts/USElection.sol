// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/access/Ownable.sol";

contract USElection {
    uint8 public constant BIDEN = 1;
    uint8 public constant TRUMP = 2;

    bool public electionEnded;

    mapping(uint8 => uint8) public seats;
    mapping(string => bool) public resultsSubmitted;

    struct StateResult {
        string name;
        uint256 votesBiden;
        uint256 votesTrump;
        uint8 stateSeats;
    }

    modifier onlyActiveElection() {
        require(!electionEnded, "The election has ended already");
        _;
    }

    function submitStateResult(StateResult calldata result)
        public
        onlyActiveElection
    {
        require(result.stateSeats > 0, "States must have at least 1 seat");
        require(
            result.votesBiden != result.votesTrump,
            "There cannot be a tie"
        );
        require(
            !resultsSubmitted[result.name],
            "This state result was already submitted!"
        );

        uint8 winner;
        if (result.votesBiden > result.votesTrump) {
            winner = BIDEN;
        } else {
            winner = TRUMP;
        }

        seats[winner] += result.stateSeats;
        resultsSubmitted[result.name] = true;

        emit LogStateResult(winner, result.stateSeats, result.name);
    }

    function currentLeader() public view returns (uint8) {
        if (seats[BIDEN] > seats[TRUMP]) {
            return BIDEN;
        }
        if (seats[TRUMP] > seats[BIDEN]) {
            return TRUMP;
        }
        return 0;
    }

    event LogStateResult(uint8 winner, uint8 stateSeats, string state);
    event LogElectionEnded(uint256 winner);

    function endElection() public onlyActiveElection {
        electionEnded = true;
        emit LogElectionEnded(currentLeader());
    }
}
