// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
    /// Structs
    struct VoterInfo {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }

    struct Proposal {
        string description;
        uint256 voteCount;
    }

    enum State {
        VoterRegistration,
        ProposalRegistration,
        Voting,
        VoteFinished
    }

    /// Storage
    State public currentState = State.VoterRegistration;
    mapping(address => VoterInfo) public voters;
    Proposal[] public proposals;
    uint256 private _winningProposalId;

    /// Events
    event StateChanged(State newState);
    event VoterRegistered(address voterAddress);
    event ProposalRegistered(uint256 proposalId, string desc);
    event Voted(address voter, uint256 proposalId);

    // Errors
    error VoterNotRegistered();
    error VoterAlreadyRegistered();
    error VoterAlreadyVoted();
    error ProposalNotFound(uint256 index);
    error ProposalsEmpty();
    error InvalidStateForThisAction(State currentState);

    constructor() Ownable(_msgSender()) {}

    modifier onlyVoters() {
        if (!voters[_msgSender()].isRegistered) revert VoterNotRegistered();
        _;
    }

    modifier checkState(State stateNeeded) {
        if (currentState != stateNeeded) revert InvalidStateForThisAction(currentState);
        _;
    }

    modifier checkArrayRange(uint256 index) {
        if (proposals.length == 0) revert ProposalsEmpty();
        if (index > proposals.length - 1) revert ProposalNotFound(index);
        _;
    }

    function nextStep() external onlyOwner {
        if (currentState == State.VoteFinished) revert InvalidStateForThisAction(currentState);
        currentState = State(uint256(currentState) + 1);
        if (currentState == State.VoteFinished) _voteCounting();
        emit StateChanged(currentState);
    }

    function registerVoter(address voterAddress) external onlyOwner checkState(State.VoterRegistration) {
        if (voters[voterAddress].isRegistered) revert VoterAlreadyRegistered();
        voters[voterAddress].isRegistered = true;
        emit VoterRegistered(voterAddress);
    }

    function registerProposal(string calldata proposalDesc) external onlyVoters checkState(State.ProposalRegistration) {
        proposals.push(Proposal(proposalDesc, 0));
        emit ProposalRegistered(proposals.length - 1, proposalDesc);
    }

    function vote(uint256 proposalId)
        external
        onlyVoters
        checkState(State.Voting)
        checkArrayRange(proposalId)
    {
        if (voters[_msgSender()].hasVoted) revert VoterAlreadyVoted();
        voters[_msgSender()].hasVoted = true;
        voters[_msgSender()].votedProposalId = proposalId;
        ++proposals[proposalId].voteCount;
        emit Voted(_msgSender(), proposalId);
    }

    function getWinner()
        external
        view
        onlyVoters
        checkState(State.VoteFinished)
        checkArrayRange(_winningProposalId)
        returns (Proposal memory)
    {
        return proposals[_winningProposalId];
    }

    function _voteCounting() private checkArrayRange(_winningProposalId) {
        uint256 max;
        uint256 maxIndex;
        for (uint256 i = 0; i < proposals.length; ++i)
            if (proposals[i].voteCount > max) {
                max = proposals[i].voteCount;
                maxIndex = i;
            }

        // if no vote proposal[0] wins
        // if equal number of votes for multiple proposals lower index wins
        _winningProposalId = maxIndex;
    }
}