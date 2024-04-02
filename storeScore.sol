// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/access/Ownable.sol";

contract storeScore is Ownable(msg.sender) {

	struct Match {
		uint matchId;
		uint8 player1Score;
		uint8 player2Score;
		string player1Id;
		string player2Id;
		string winner;
	}

	mapping(uint => uint[]) private tournament;
	mapping(string => uint[]) private playerMatch;
	mapping(uint => Match) private match_map;

	function addTournament(uint[] memory _r_matchId, uint _tournamentId, uint8[] memory _player1Score, uint8[] memory _player2Score, string[] memory _player1Id, string[] memory _player2Id, string[] memory _winner) external onlyOwner {
		for(uint i = 0; i < _r_matchId.length; i++) {
			addMatch(_r_matchId[i], _tournamentId, _player1Score[i], _player2Score[i],_player1Id[i], _player2Id[i],_winner[i]);
		}
	}

	function addMatch(uint _r_matchId, uint _tournamentId,  uint8 _player1Score, uint8 _player2Score, string memory _player1Id, string memory _player2Id, string memory _winner) public onlyOwner {
		require(match_map[_r_matchId].matchId == 0, "This match already exist");
		
		Match memory newMatch = Match(_r_matchId, _player1Score, _player2Score, _player1Id, _player2Id, _winner);
		match_map[_r_matchId] = newMatch;
		playerMatch[_player1Id].push(_r_matchId);
		playerMatch[_player2Id].push(_r_matchId);
		if(_tournamentId != 0)
			tournament[_tournamentId].push(_r_matchId);
	}

	function getTournament(uint _tournamentId) external view returns (Match[] memory) {
		require(tournament[_tournamentId].length > 0, "No tournamenet found for this ID");

		Match[] memory tournamentMatchs = new Match[](tournament[_tournamentId].length);
		for(uint i = 0; i < tournament[_tournamentId].length; i++) {
			tournamentMatchs[i]= match_map[tournament[_tournamentId][i]];
		}

		return (tournamentMatchs);
	}

	function getPlayerMatchs(string memory _playerName) external view returns (Match[] memory) {
		require(playerMatch[_playerName].length > 0, "No match found for this player");

		Match[] memory playerNameMatchs = new Match[](playerMatch[_playerName].length);
		for(uint i = 0; i < playerMatch[_playerName].length; i++) {
			playerNameMatchs[i] = match_map[playerMatch[_playerName][i]];
		}

		return (playerNameMatchs);
	}

	function getMatchById(uint _r_matchId) external view returns (Match memory) {
		require(match_map[_r_matchId].matchId != 0, "This match doesn't exist");

		return (match_map[_r_matchId]);
	}
}