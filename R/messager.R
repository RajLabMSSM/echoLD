messager<- function(..., v = 1) {
  msg <- paste(...)
  if (v == 1) {
    #message(paste("In function ->", sys.call(1)[1], "....", msg),  sep = " ")
    get_call = match.call(definition = sys.function(sys.parent(1)),
                          call = sys.call(sys.parent(1)))
    message("In function ", get_call[1]," ----> ", msg)
    
  } else if (v == 2) {
    message(msg)
    message("\n Showing the backtrace: \n")
    print(rlang::trace_back())
  } else {
    message(msg)
  }
}

