#' @name get_matchups
#' @rdname get_matchups
#' @title Download matchups data for NBA game
#'
#' @description  Download and process NBA.com matchups data for given game
#'
#' @param game_id Game's ID in NBA.com DB
#' @param verbose Defalt TRUE - prints additional information
#'
#' @return Dataset containing data about specified game matchups
#'
#' @author Patrick Chodowski, \email{Chodowski.Patrick@@gmail.com}
#' @keywords NBAr, Boxscores, players, Game, matchups
#'
#' @examples
#'
#' get_matchups(21701181)
#'
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
#' @export get_matchups
#'

get_matchups <- function(game_id, verbose = TRUE){


  tryCatch({

    link <- glue("http://stats.nba.com/stats/boxscorematchups?GameID=00{game_id}")

    verbose_print(verbose, link)
    result_sets_df <- rawToChar(GET(link, add_headers(.headers = c('Referer' = 'http://google.com')))$content) %>% fromJSON()

    index <- which(result_sets_df$resultSets$name == "PlayerMatchupsStats")

    dataset <- result_sets_df$resultSets$rowSet[index][1] %>%
      as.data.frame(stringsAsFactors=F) %>%
      as_tibble() %>%
      set_names(tolower(unlist(result_sets_df$resultSets$headers[index]))) %>%
      mutate_if(check_if_numeric, as.numeric) %>%
      mutate_at(vars(- contains('_pct')), c_to_int)

    verbose_dataset(verbose, dataset)
    return(dataset)}, error=function(e) NULL)
}

