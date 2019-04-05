/*
* Given a list of career stats for a team of rugby players,
* a list of player names, and a list of team names, in the format below:
*
* players
* {
*     "players": [
*         {
*             "id": 112814,
*             "matches": "123",
*             "tries": "11"
*         }
*     ],
*     "team": {
*         "id": 10,
*         "coach": "John Simmons"
*     }
* }
* names
* {
*     "names": [
*         {
*             "id": 112814,
*             "name": "Greg Growden"
*         }
*     ]
* }
* teams
* {
*     "teams": [
*         {
*             "id": 10,
*             "team": "NSW Waratahs"
*         }
*     ]
* }
* Write a program that returns a 'team sheet' that lists
* the team, coach, players in that order in the following list format.
*
* [
*     "Team Name, coached by CoachName",
*     "1. PlayerName",
*     "2. PlayerName"
*     ....
* ]
*
* Where each element is a string, and the order of the players
* is ordered by the most number of matches played to the least number of matches played.
*
* For example, the following input should match the
* following output exactly.
*
* input data
* {
*     "players": [
*         {"id": 1,"matches": "123", "tries": "11"},
*         {"id": 2,"matches": "1",   "tries": "1"},
*         {"id": 3,"matches": "2",   "tries": "5"}
*     ],
*     "team": {
*         "id": 10,
*         "coach": "John Simmons"
*     }
* }
*
* {
*     "names": [
*         {"id": 1, "John Fake"},
*         {"id": 2, "Jimmy Alsofake"},
*         {"id": 3, "Jason Fakest"}
*     ]
* }
*
* {
*     "teams": [
*         {"id": 10, "Greenbay Packers"},
*     ]
* }
*
* output
* [
*     "Greenbay Packers, coached by John Simmons",
*     "1. John Fake",
*     "2. Jason Fakest",
*     "3. Jimmy Alsofake"
* ]
*
* test with
* `node test.js team.json names.json teams.json`
*/

function makeTeamList(teamData, namesData, teamsData) {

    const coachname = teamData["team"]["coach"];
    const teamid = teamData["team"]["id"];

    var playersid = [];

    for (var i = teamData.length; i >= 0; i--){
        for (var key in teamData[i]){
            if (teamData[i] === 'players' && key === 'id'){
                playersid.push(teamData[i][key]);
            }
        }
    }

    for (var i = teamsData.length; i >= 0; i--){
        for (var key in teamsData[i]){
            if (key === 'id' && teamsData[i][key] === teamid){
            	var teamname = teamsData[i]["team"];
           	break;
            }
        }
    }

    var info = [];
    info.push(teamname +  ', coached by ' + coachname);

    var seq = 1;
    for (var i = namesData.length; i >= 0; i--){
        for (var key in namesData[i]){
            if (key === 'id'){
                var seqstr = String(seq) + '. ';
                info.push(seqstr + namesData[i]["name"]);
                seq += 1;
            }
        }
    }
    return info;
}
module.exports = makeTeamList;
