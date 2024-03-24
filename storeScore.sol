// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";

contract storeScore is Ownable {

	struct Match {
		uint matchId;
		string player1Name;
		string player2Name;
		uint player1Score;
		uint player2Score;
		string winner;
	}

	mapping(uint => uint[]) private tournament;
	mapping(string => uint[]) private playerMatch;
	mapping(uint => Match) private match_map;

	function addMatch(uint matchId, uint tournamentId, string player1Name, string player2Name, uint player1Score, uint player2Score, string winner) external onlyOwner {
		require(match_map[matchId].id == 0, "This match already exist");
		Match memory newMatch = Match(matchId, player1Name, player2Name, player1Score, player2Score, winner);

		match_map[matchId] = newMatch;
		playerMatch[player1Name].push(matchId);
		playerMatch[player2Name].push(matchId);
		if(tournamentId != 0)
			tournament[tournamentId].push(matchId);
	}

	function getTournament(uint tournamentId) external view returns (Match[] memory) {

		require(tournament[tournamentId].length > 0, "No tournamenet found for this ID");

		Match[] memory tournamentMatchs;
		for(uint i = 0; i < tournament[tournamentId].length; i++)
		{
			tournamentMatchs.push(match_map[tournament[tournamentId][i]]);
		}
		return (tournamentMatchs);
	}
}

