rankhospital <- function(state, outcome, num = "best") {
  
  outcome_pick <- NULL
  #selects the right collum index according to the chosen outcome
  
  if (outcome == "heart attack"){
    outcome_pick <- 11
  }else if (outcome == "pneumonia"){
    outcome_pick <- 23
  }else if(outcome == "heart failure"){
    outcome_pick <- 17
  } else {
    outcome_pick <- 0
  }
  
  outcome_table <- read.csv("outcome-of-care-measures.csv")
  
  outcome_pick
  # creates a dataframe with only the State Name, Hospital Name and 
  #chosen outcome collums
  
  raw_table <- outcome_table[c(2,7, as.numeric(outcome_pick))]
  
  #gets the list of unique states in the dataset
  states <- raw_table[["State"]]
  list_states <- unique(states) 
  
  #checks to see if the given state exists
  stateExists <- state %in% list_states # checks to see if the state is valid
  
  #checks to see if the given state and outcome are valid
  if(stateExists==FALSE){
    stop("invalid state")
    
  }else if (outcome_pick == 0){
    stop("invalid outcome")
    
  }else{
    #checks the value of the num argument
    ##gets the data from only the selected state
    raw_to_clean <- complete.cases(as.numeric(raw_table[, 3]))
    raw_data_cleaned <- raw_table[raw_to_clean, ]
    
    #removes any data containing NA's , regular method was still leaving Not availables 
    raw_data_na_to_clean <- raw_data_cleaned[, 3] == "Not Available"
    outcome_cleaned <- raw_data_cleaned[!raw_data_na_to_clean, ]
    
    #filters the data according to the picked state
    
    states_to_remove <- (outcome_cleaned[["State"]] == as.character(state))
    outcome_by_state_final <- outcome_cleaned[states_to_remove, ]
    
    #note : the collumn for the picked outcome will always be index 3
    
    #forces conversion of collumn 3 to numeric
    outcome_by_state_final[,3] <- as.numeric(as.character(outcome_by_state_final[,3]))
    #forces conversion of collum names to characters
    outcome_by_state_final[,1] <- as.character(outcome_by_state_final[,1])
    
    if (num == "best"){
      
      #sorts the data in terms of the outcome in ascending and selects the very first item in the table
      hospitals_sorted <- outcome_by_state_final[order(outcome_by_state_final[,3],outcome_by_state_final[,1]), ]
      as.character(hospitals_sorted[1,1])
      
    }else if (num == "worst"){
      #sorts the data in a descending way and selects the very first item in the table
      hospitals_sorted <- outcome_by_state_final[order(-outcome_by_state_final[,3],outcome_by_state_final[,1]), ]
      as.character(hospitals_sorted[1,1])
      
    }else if(is.numeric(num)& (num>0)){
      #sorts the data in an ascending manner in terms of the outcome and the hospital name, and selects the NUM item in the table
      hospitals_sorted <- outcome_by_state_final[order(as.numeric(outcome_by_state_final[,3]), outcome_by_state_final[,1]), ]
      
      #ensures that a result is only returned when the num argument is less or equal than the number of rows
      if(nrow(hospitals_sorted)>=num){
        as.character(hospitals_sorted[num,1])
        #hospitals_sorted
      }else{
        NA
      }
      
    }
  }
  
}