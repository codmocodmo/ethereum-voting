pragma solidity ^0.4.18;
// written for Solidity version 0.4.18 and above that doesnt break functionality

contract Voting {
    // an event that is called whenever a proposal is added so the frontend could
    // appropriately display the proposal with the right element id (it is used
    // to vote for the proposal, since it is one of arguments for the function "vote")
    event Addedproposal(uint proposalID);

    // describes a shareholder, which has an id and the ID of the proposal they voted for
    address owner;
    function Voting()public {
        owner=msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    struct shareholder {
        bytes32 uid; // bytes32 type are basically strings
        uint proposalIDVote;
    }
    // describes a proposal
    struct proposal {
        bytes32 name;
        bytes32 party; 
        // "bool doesExist" is to check if this Struct exists
        // This is so we can keep track of the proposals 
        bool doesExist; 
    }

    // These state variables are used keep track of the number of proposals/shareholders 
    // and used to as a way to index them     
    uint numproposals; // declares a state variable - number Of proposals
    uint numshareholders;

    
    // Think of these as a hash table, with the key as a uint and value of 
    // the struct proposal/shareholder. These mappings will be used in the majority
    // of our transactions/calls
    // These mappings will hold all the proposals and shareholders respectively
    mapping (uint => proposal) proposals;
    mapping (uint => shareholder) shareholders;
    
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     *  These functions perform transactions, editing the mappings *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

    function addproposal(bytes32 name, bytes32 party) onlyOwner public {
        // proposalID is the return variable
        uint proposalID = numproposals++;
        // Create new proposal Struct with name and saves it to storage.
        proposals[proposalID] = proposal(name,party,true);
        Addedproposal(proposalID);
    }

    function vote(bytes32 uid, uint proposalID) public {
        // checks if the struct exists for that proposal
        if (proposals[proposalID].doesExist == true) {
            uint shareholderID = numshareholders++; //shareholderID is the return variable
            shareholders[shareholderID] = shareholder(uid,proposalID);
        }
    }

    /* * * * * * * * * * * * * * * * * * * * * * * * * * 
     *  Getter Functions, marked by the key word "view" *
     * * * * * * * * * * * * * * * * * * * * * * * * * */
    

    // finds the total amount of votes for a specific proposal by looping
    // through shareholders 
    function totalVotes(uint proposalID) view public returns (uint) {
        uint numOfVotes = 0; // we will return this
        for (uint i = 0; i < numshareholders; i++) {
            // if the shareholder votes for this specific proposal, we increment the number
            if (shareholders[i].proposalIDVote == proposalID) {
                numOfVotes++;
            }
        }
        return numOfVotes; 
    }

    function getNumOfproposals() public view returns(uint) {
        return numproposals;
    }

    function getNumOfshareholders() public view returns(uint) {
        return numshareholders;
    }
    // returns proposal information, including its ID, name, and party
    function getproposal(uint proposalID) public view returns (uint,bytes32, bytes32) {
        return (proposalID,proposals[proposalID].name,proposals[proposalID].party);
    }
}

