parseCondition <- function(conditionText) {
  category <- substr(conditionText, 1, 1)
  operator <- substr(conditionText, 2, 2)
  value <- substr(conditionText, 3, nchar(conditionText))
  return(list(category=category, operator=operator, value=as.integer(value)))
}

parseRule <- function(ruleText) {
  splitted <- strsplit(ruleText, split = ":")[[1]]

  if (length(splitted) == 1) {
    target <- splitted[1]
    condition <- NULL
  } else {
    condition <- parseCondition(splitted[1])
    target <- splitted[2]
  }
  return(list(condition=condition, target=target))
}

parseWorkFlow <- function(workFlowLine) {
  pattern <- "([^{]*)[{](.*)[}]"
  name <- sub(pattern, "\\1", workFlowLine)
  rulesText <- sub(pattern, "\\2", workFlowLine)
  splittedRules <- strsplit(rulesText, ",")[[1]]
  rules <- lapply(splittedRules, parseRule)

  return(list(name = name, rules = rules))
}

parseRating <- function(rating) {
  splitted <- strsplit(rating, split = "=")[[1]]
  return (list(category=splitted[1], rating=as.integer(splitted[2])))
}

parsePart <- function(partLine) {
  splitted <- strsplit(substr(partLine, 2, nchar(partLine) - 1), ",")[[1]]
  ratingList <- lapply(splitted, parseRating)
  ratings <- list()
  for (rating in ratingList) {
    ratings[[rating$category]] <- rating$rating
  }
  return (ratings)
}

parseFile <- function(fileName) {
  lines <- readLines(fileName)
  emptyLineIndex <- which(lines == "")
  workFlowLines <- lines[1:(emptyLineIndex-1)]
  partLines <- lines[(emptyLineIndex+1):length(lines)]

  workFlowList <- lapply(workFlowLines, parseWorkFlow)

  workFlows <- list()
  for (workFlow in workFlowList) {
    workFlows[[workFlow$name]] = workFlow$rules
  }
  
  parts <- lapply(partLines, parsePart)
  return(list(workFlows=workFlows, parts=parts))
}  

partAccepted <- function(part, workFlows) {
  workflowName <- "in"

  while(TRUE) {
   
    if (workflowName == "A") {
      return(TRUE)
    }

    if (workflowName == "R") {
      return(FALSE)
    }
    
    workflow = workFlows[[workflowName]]
    for (rule in workflow) {
      if (is.null(rule$condition)) {
        workflowName = rule$target   
        break;
      } else {
        condition <- rule$condition
        categoryValue = part[[condition$category]]
        if (condition$operator == ">") {
          if (categoryValue > condition$value) {
            workflowName = rule$target
            break;
          }
        } else if (condition$operator == "<") {
          if (categoryValue < condition$value) {
            workflowName = rule$target
            break;
          }
        }
      }
    }
  }
}

solve <- function(workFlows, parts) {
  sum <- 0
  for (part in parts) {
    if (partAccepted(part, workFlows)) {
      partSum <- part$x + part$m + part$s + part$a
      #print(partSum)
      sum <- sum + partSum
    }
  }
  print(sum)
}

calcCombinations <- function(constraints) {
  result <- 1
  for (constraint in constraints) {
    diff <- (constraint[[2]] - constraint[[1]]) + 1
    result <- result * diff
  }
  return (result)
}

allCombinations <- function(constraints, workflowName, workFlows) {
  workflow = workFlows[[workflowName]]

  if (workflowName == "A") {
    return(calcCombinations(constraints))
  }

  if (workflowName == "R") {
    return(0)
  }

  comb <- 0
  
  for (rule in workflow) {
    workflowName = rule$target   
    if (is.null(rule$condition)) {
      return(comb + allCombinations(constraints, workflowName, workFlows))
    } else {
      condition <- rule$condition
      constraint = constraints[[condition$category]]
      if (condition$operator == ">") {
        newconstraints <- constraints
        newconstraint <- list(condition$value + 1, constraint[[2]])
        newconstraints[[condition$category]] <- newconstraint

        constraints[[condition$category]] <- list(constraint[[1]], condition$value)
        
        comb <- comb + allCombinations(newconstraints, workflowName, workFlows);
      } else if (condition$operator == "<") {
        newconstraints <- constraints
        newconstraints[[condition$category]] <- list(constraint[[1]], condition$value-1)
        constraints[[condition$category]] <- list(condition$value, constraint[[2]])
        comb <- comb + allCombinations(newconstraints, workflowName, workFlows);
      }
    }
  }
}

solve2 <- function(workFlows) {
  initialConstraints <- list( 
    x = list(1,4000), m = list(1,4000), s = list(1,4000), a = list(1,4000))
  
  combinations <- allCombinations(initialConstraints, "in", workFlows)
  print(format(combinations, scientific = FALSE))
}

input <- parseFile("input")
solve(input$workFlows, input$parts)
solve2(input$workFlows)
