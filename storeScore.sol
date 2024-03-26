// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";

contract storeScore is Ownable(msg.sender) {

	struct Match {
		uint matchId;
		uint8 player1Score;
		uint8 player2Score;
		string player1Name;
		string player2Name;
		string winner;
	}

	mapping(uint => uint[]) private tournament;
	mapping(string => uint[]) private playerMatch;
	mapping(uint => Match) private match_map;

	function addMatch(uint r_matchId, uint tournamentId, string memory player1Name, string memory player2Name, uint8 player1Score, uint8 player2Score, string memory winner) external onlyOwner {
		require(match_map[r_matchId].matchId == 0, "This match already exist");
		
		Match memory newMatch = Match(r_matchId, player1Score, player2Score, player1Name, player2Name, winner);
		match_map[r_matchId] = newMatch;
		playerMatch[player1Name].push(r_matchId);
		playerMatch[player2Name].push(r_matchId);
		if(tournamentId != 0)
			tournament[tournamentId].push(r_matchId);
	}

	function getTournament(uint tournamentId) external view returns (Match[] memory) {
		require(tournament[tournamentId].length > 0, "No tournamenet found for this ID");

		Match[] memory tournamentMatchs = new Match[](tournament[tournamentId].length);
		for(uint i = 0; i < tournament[tournamentId].length; i++) {
			tournamentMatchs[i]= match_map[tournament[tournamentId][i]];
		}

		return (tournamentMatchs);
	}

	function getPlayerMatchs(string memory playerName) external view returns (Match[] memory) {
		require(playerMatch[playerName].length > 0, "No match found for this player");

		Match[] memory playerNameMatchs = new Match[](playerMatch[playerName].length);
		for(uint i = 0; i < playerMatch[playerName].length; i++) {
			playerNameMatchs[i] = match_map[playerMatch[playerName][i]];
		}

		return (playerNameMatchs);
	}

	function getMatchById(uint r_matchId) external view returns (Match memory) {
		require(match_map[r_matchId].matchId != 0, "This match doesn't exist");

		return (match_map[r_matchId]);
	}
}

