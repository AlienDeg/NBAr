% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_lineups.R
\name{get_lineups}
\alias{get_lineups}
\title{Download Lineups data}
\usage{
get_lineups(
  season,
  group_quantity,
  measure_type,
  team_id = "0",
  date_from = "",
  date_to = "",
  opponent_team_id = "0",
  outcome = "",
  per_mode = "Totals",
  season_segment = "",
  game_segment = "",
  season_type = "Regular+Season",
  verbose = TRUE
)
}
\arguments{
\item{season}{Number of the year in which season started}

\item{group_quantity}{Number of players in a lineup}

\item{measure_type}{Type of statistics}

\item{team_id}{Specify team id from nba.com database. Default "0" means all teams.}

\item{date_from}{Day from which data will be collected. It is set in MM/DD/YYYY format and by default is not specified, so data is calculated for whole season.}

\item{date_to}{Day to which data will be collected. It is set in MM/DD/YYYY format and by default is not specified, so data is calculated for whole season.}

\item{opponent_team_id}{Filter by opponent's team id from nba.com database. Default "0" means all teams.}

\item{outcome}{Filter by game result. It can be a loss (L) or a win (W). By default parameter is an empty string, so both are taken into account. c("","W","L")}

\item{per_mode}{Specify if you want data divided per game or totals. Default parameter is "PerGame". c("PerGame","Totals")}

\item{season_segment}{Choose season half for the data. Empty string means whole season and it is set by default. c("","Post All-Star","Pre All-Star")}

\item{game_segment}{Choose game half for the data. Empty string means whole game and it is set by default. c("","First Half","Overtime","Second Half")}

\item{season_type}{Choose data for preseason, regular season or postseason. Default parameter is "Regular Season". c("Regular Season","Playoffs","Pre Season","All Star")}

\item{verbose}{Defalt TRUE - prints additional information}
}
\description{
Download and process NBA.com lineups data from http://stats.nba.com/lineups/traditional/
}
\examples{

season = '2017'
group_quantity = 2
measure_type = c("Base","Advanced","Misc","Four+Factors","Scoring","Opponent")[1]
team_id = 0
date_from = '01/01/2018'
date_to = '01/25/2018'
opponent_team_id = 0
outcome = c("","W","L")[1]
per_mode =  c("Totals","PerGame","MinutesPer","Per48","Per40","Per36")[1]
season_segment = c("","Post+All-Star","Pre+All-Star")[1]
game_segment = c("","First+Half","Overtime","Second+Half")[1]
season_type = c("Regular+Season","Playoffs","PreSeason","All+Star")[1]

get_lineups(season = '2017',
            group_quantity = 5,
            measure_type = "Base",
            team_id="0",
            date_from="",
            date_to="",
            opponent_team_id="0",
            outcome="",
            per_mode="Totals",
            season_segment="",
            game_segment="",
            season_type="Regular+Season")


}
\author{
Patrick Chodowski, \email{Chodowski.Patrick@gmail.com}
}
\keyword{NBAr,}
\keyword{Thibodeau}
\keyword{lineups,}
\keyword{minutes}
\keyword{players,}
