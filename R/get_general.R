#' @name get_general
#' @rdname get_general
#' @title Download general data for Players and Teams
#'
#' @description  Download and process NBA.com general data from http://stats.nba.com/players/traditional/, http://stats.nba.com/teams/advanced/ etc.
#'
#' @param season Number of the year in which season started
#' @param type Specify if data is for Team or Player   c("Player,"Team")
#' @param measure_type Specify which statistics group you want to download. c("Base","Advanced","Misc","Scoring","Usage","Opponent","Defense", "Four+Factors")
#' @param per_mode Specify if you want data divided per game or totals. Default parameter is "PerGame". c("PerGame","Totals")
#' @param season_type Choose data for preseason, regular season or postseason. Default parameter is "Regular+Season". c("Regular+Season","Playoffs","Pre+Season","All+Star")
#' @param season_segment Choose season half for the data. Empty string means whole season and it is set by default. c("","Post+All-Star","Pre+All-Star")
#' @param game_segment Choose game half for the data. Empty string means whole game and it is set by default. c("","First+Half","Overtime","Second Half")
#' @param period Choose game period for the data. 0 means whole game and it is set by default. as.character(c(0:4))
#' @param date_from Day from which data will be collected. It is set in MM/DD/YYYY format and by default is not specified, so data is calculated for whole season.
#' @param date_to Day to which data will be collected. It is set in MM/DD/YYYY format and by default is not specified, so data is calculated for whole season.
#' @param outcome Filter by game result. It can be a loss (L) or a win (W). By default parameter is an empty string, so both are taken into account. c("","W","L")
#' @param opponent_team_id Filter by opponent's team id from nba.com database. Default "0" means all teams.
#' @param team_id Specify team id from nba.com database. Default "0" means all teams.
#' @param verbose Defalt TRUE - prints additional information
#' @return Dataset from stats.nba.com
#'
#' @author Patrick Chodowski, \email{Chodowski.Patrick@@gmail.com}
#' @keywords NBAr, general, traditional, advanced players, teams,
#'
#' @examples
#'
#' season <- "2016"
#' type <- c("Player","Team")[1]
#'
#' measure_type <- c("Base",
#'                  "Advanced",
#'                  "Misc",
#'                  "Scoring",
#'                  "Usage",
#'                  "Opponent",
#'                  "Defense",
#'                  "Four+Factors"
#'                  )[1]
#'
#' per_mode <- c("PerGame","Totals")[1]
#' season_type <- c("Regular+Season","Playoffs","Pre+Season","All+Star")[1]
#' season_segment <- c("","Post+All-Star","Pre+All-Star")[1]
#' game_segment <- c("","First+Half","Overtime","Second+Half")[1]
#' period <- as.character(c(0:4))[1]
#' date_from <- "01/01/2017"
#' date_to <- "04/30/2017"
#' outcome <- c("","W","L")[1]
#' opponent_team_id <- 0
#' team_id <- 0
#' general_dataset <- get_general(
#'                               season,
#'                               type,
#'                               measure_type,
#'                               per_mode,
#'                               season_type,
#'                               season_segment,
#'                               game_segment,
#'                               date_from,
#'                               date_to,
#'                               outcome,
#'                               period,
#'                               opponent_team_id,
#'                               team_id
#'                               )
#'
#' @importFrom  lubridate second minute
#' @import dplyr
#' @import tidyr
#' @import httr
#' @importFrom purrr set_names
#' @import tibble
#' @importFrom glue glue
#' @importFrom magrittr %>%
#' @importFrom jsonlite fromJSON
#' @export get_general




get_general <- function(season,
                        type,
                        measure_type,
                        per_mode = "PerGame",
                        season_type = "Regular+Season",
                        season_segment = "",
                        game_segment ="",
                        date_from = "",
                        date_to = "",
                        outcome = "",
                        period = "0",
                        opponent_team_id = "0",
                        team_id = "0",
                        verbose = TRUE
){

  tryCatch({
    season_id <- paste(season, as.numeric(substring(season,3,4))+1,sep="-")

link <- glue("https://stats.nba.com/stats/leaguedash{type}stats?",
"College=&Conference=&Country=&DateFrom={date_from}",
"&DateTo={date_to}",
"&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment={game_segment}",
"&Height=&LastNGames=0&LeagueID=00&Location=&MeasureType={measure_type}",
"&Month=0&OpponentTeamID={opponent_team_id}",
"&Outcome={outcome}",
"&PORound=0&PaceAdjust=N&PerMode={per_mode}",
"&Period={period}",
"&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season={season_id}",
"&SeasonSegment={season_segment}",
"&SeasonType={season_type}",
"&ShotClockRange=&StarterBench=&TeamID={team_id}",
"&VsConference=&VsDivision=&Weight=")

verbose_print(verbose, link)
result_sets_df <- rawToChar(GET(link, add_headers(.headers = c('Referer' = 'http://google.com')))$content) %>% fromJSON()
index <- which(result_sets_df$resultSets$name == paste("LeagueDash",type,"Stats",sep=""))

dataset <- result_sets_df$resultSets$rowSet[index][1] %>%
  as.data.frame(stringsAsFactors=F) %>%
  as_tibble() %>%
  mutate_if(check_if_numeric, as.numeric) %>%
  set_names(tolower(unlist(result_sets_df$resultSets$headers[index]))) %>%
  mutate_at(vars(- contains('_pct')), c_to_int)

verbose_dataset(verbose, dataset)


return(dataset)}, error=function(e) NULL)
}





