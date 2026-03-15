test_that(".onLoad sets .datatable.aware", {
    # Simply verify the package loads without error
    # .onLoad sets .datatable.aware which is needed for
    # data.table compatibility in packages
    testthat::expect_no_error(
        echoLD:::.onLoad(libname = .libPaths()[1], pkgname = "echoLD")
    )
})
