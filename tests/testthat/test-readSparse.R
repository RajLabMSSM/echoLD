test_that("readSparse works", {
  
    LD_matrix <- echodata::BST1_LD_matrix
    run_tests <- function(LD_matrix,
                          ld_mat){ 
        testthat::expect_true(is_sparse_matrix(ld_mat))
        testthat::expect_equal(LD_matrix,as.matrix(ld_mat))
        
    }
    #### csv #### 
    LD_path <- tempfile(fileext = ".csv")
    utils::write.csv(LD_matrix,
                     file = LD_path,
                     row.names = TRUE)
    ld_mat <- readSparse(LD_path = LD_path)
    run_tests(LD_matrix, ld_mat)
    #### tsv #### 
    LD_path <- tempfile(fileext = ".tsv")
    utils::write.table(LD_matrix,
                     file = LD_path,
                     row.names = TRUE, sep="\t")
    ld_mat <- readSparse(LD_path = LD_path)
    run_tests(LD_matrix, ld_mat)
    
    #### txt #### 
    LD_path <- tempfile(fileext = ".txt")
    utils::write.table(LD_matrix,
                       file = LD_path,
                       row.names = TRUE, sep=" ")
    ld_mat <- readSparse(LD_path = LD_path)
    run_tests(LD_matrix, ld_mat)
    
    #### tsv.gz #### 
    LD_path <- tempfile(fileext = ".tsv.gz")
    data.table::fwrite(data.table::data.table(LD_matrix,
                                              keep.rownames = "rsid"),
                       file = LD_path, 
                       sep = "\t")
    ld_mat <- readSparse(LD_path = LD_path)
    run_tests(LD_matrix, ld_mat)
    
    
    #### mtx #### 
    ## Matrix Market (MM) format doesn't save the row/col names. 
    ## So not really useful for our purposes.
    LD_path <- tempfile(fileext = ".mtx.gz") 
    Matrix::writeMM(obj = methods::as(LD_matrix,"sparseMatrix"), 
                    file = LD_path) 
    ld_mat <- readSparse(LD_path = LD_path)
    testthat::expect_equal(Matrix::mean(ld_mat),
                           Matrix::mean(LD_matrix))
    testthat::expect_null(rownames(ld_mat))
    testthat::expect_null(colnames(ld_mat))
})
