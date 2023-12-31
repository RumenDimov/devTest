USE [NBA]
GO
/****** Object:  StoredProcedure [dbo].[GetAllTeamsStatsWithUrl]    Script Date: 05/09/2023 16:05:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllTeamsStatsWithUrl]
AS
BEGIN
    WITH LastGame AS (
        SELECT
            G.HomeTeamID AS TeamID,
            MAX(G.GameDateTime) AS LastGameDateTime
        FROM Games G
        GROUP BY G.HomeTeamID
        UNION ALL
        SELECT
            G.AwayTeamID AS TeamID,
            MAX(G.GameDateTime) AS LastGameDateTime
        FROM Games G
        GROUP BY G.AwayTeamID
    )

    SELECT
        T.Name AS [Name],
        T.Stadium AS [Stadium],
        T.Logo AS [Logo],
        T.URL AS [URL], -- Added URL column
        COUNT(G.GameID) AS [Played],
        SUM(CASE WHEN G.HomeScore > G.AwayScore THEN 1 ELSE 0 END) AS [Won],
        SUM(CASE WHEN G.HomeScore < G.AwayScore THEN 1 ELSE 0 END) AS [Lost],
        SUM(CASE WHEN G.HomeTeamID = T.TeamID OR G.AwayTeamID = T.TeamID THEN 1 ELSE 0 END) AS [PlayedHome],
        SUM(CASE WHEN G.HomeTeamID <> T.TeamID AND G.AwayTeamID <> T.TeamID THEN 1 ELSE 0 END) AS [PlayedAway],
        MAX(CASE WHEN G.HomeScore > G.AwayScore THEN G.HomeScore - G.AwayScore ELSE G.AwayScore - G.HomeScore END) AS [BiggestWin],
        MAX(CASE WHEN G.HomeScore < G.AwayScore THEN G.AwayScore - G.HomeScore ELSE G.HomeScore - G.AwayScore END) AS [BiggestLoss],
        MAX(CONVERT(VARCHAR, LastGame.LastGameDateTime, 120)) AS [LastGameDate],
        MAX(LastGameStadium.Stadium) AS [LastGameStadium],
        (SELECT P.Name
         FROM Players P
         WHERE P.PlayerID = (
             SELECT TOP 1 G.MVPPlayerID
             FROM Games G
             WHERE G.HomeTeamID = T.TeamID OR G.AwayTeamID = T.TeamID
             ORDER BY G.GameDateTime DESC
         )) AS [MVP]
    FROM Teams T
    LEFT JOIN Team_Player TP ON T.TeamID = TP.TeamID
    LEFT JOIN Games G ON T.TeamID = G.HomeTeamID OR T.TeamID = G.AwayTeamID
    LEFT JOIN LastGame ON T.TeamID = LastGame.TeamID
    LEFT JOIN Games LastGameDetails ON (LastGameDetails.HomeTeamID = T.TeamID OR LastGameDetails.AwayTeamID = T.TeamID) AND LastGameDetails.GameDateTime = LastGame.LastGameDateTime
    LEFT JOIN Teams LastGameStadium ON LastGameDetails.HomeTeamID = LastGameStadium.TeamID
    GROUP BY T.TeamID, T.Name, T.Stadium, T.Logo, T.URL, LastGame.LastGameDateTime, LastGameStadium.Stadium
    ORDER BY [Won] DESC;
END
GO
