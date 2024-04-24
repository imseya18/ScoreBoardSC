// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract storeScore is Ownable(msg.sender) {

	struct Match {
		uint64 matchId;
		uint64 tournamentId;
		uint64 timestamp;
		uint64 player1Id;
		uint64 player2Id;
		uint64 winner;
		uint8 player1Score;
		uint8 player2Score;
	}

	mapping(uint64 => uint64[]) private tournament;
	mapping(uint64 => uint64[]) private playerMatch;
	mapping(uint64 => Match) private match_map;

	function addTournament(uint64[] memory _r_matchId, uint64 _tournamentId, uint64[] memory _timestamp, uint8[] memory _player1Score, uint8[] memory _player2Score, uint64[] memory _player1Id, uint64[] memory _player2Id, uint64[] memory _winner) external onlyOwner {
		require(tournament[_tournamentId].length == 0, string(abi.encodePacked("This tournament already exists: ", Strings.toString(_tournamentId))));
		for(uint i = 0; i < _r_matchId.length; i++) {
			addMatch(_r_matchId[i], _tournamentId, _timestamp[i],_player1Score[i], _player2Score[i],_player1Id[i], _player2Id[i],_winner[i]);
		}
	}

	function addMatch(uint64 _r_matchId, uint64 _tournamentId, uint64 _timestamp, uint8 _player1Score, uint8 _player2Score, uint64 _player1Id, uint64 _player2Id, uint64 _winner) public onlyOwner {
		require(match_map[_r_matchId].matchId == 0, string(abi.encodePacked("This match already exists: ", Strings.toString(_r_matchId))));
		
		Match memory newMatch = Match(_r_matchId, _tournamentId, _timestamp, _player1Id, _player2Id, _winner, _player1Score, _player2Score);
		match_map[_r_matchId] = newMatch;
		playerMatch[_player1Id].push(_r_matchId);
		playerMatch[_player2Id].push(_r_matchId);
		if(_tournamentId != 0)
			tournament[_tournamentId].push(_r_matchId);
	}

	function getTournament(uint64 _tournamentId) external view returns (Match[] memory) {
		require(tournament[_tournamentId].length > 0, string(abi.encodePacked("No tournament found for this ID: ", Strings.toString(_tournamentId))));

		Match[] memory tournamentMatchs = new Match[](tournament[_tournamentId].length);
		for(uint i = 0; i < tournament[_tournamentId].length; i++) {
			tournamentMatchs[i]= match_map[tournament[_tournamentId][i]];
		}
		return (tournamentMatchs);
	}

	function getPlayerMatchs(uint64 _playerId) external view returns (Match[] memory) {
		require(playerMatch[_playerId].length > 0, string(abi.encodePacked("No match found for this PlayerID: ", Strings.toString(_playerId))));

		Match[] memory playerNameMatchs = new Match[](playerMatch[_playerId].length);
		for(uint i = 0; i < playerMatch[_playerId].length; i++) {
			playerNameMatchs[i] = match_map[playerMatch[_playerId][i]];
		}

		return (playerNameMatchs);
	}

	function getMatchById(uint64 _r_matchId) external view returns (Match memory) {
		require(match_map[_r_matchId].matchId != 0, string(abi.encodePacked("No match found for this ID: ", Strings.toString(_r_matchId))));

		return (match_map[_r_matchId]);
	}
}