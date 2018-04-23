## ROI plugin: qpOASES
## based on ecos interface

make_qpoases_signatures <- function()
    ROI_plugin_make_signature( objective = c("Q", "L"),
                               constraints = c("X", "L"),
                               types = c("C"),
                               bounds = c("X", "V"),
                               cones = c("X"),
                               maximum = c(TRUE, FALSE) )

## SOLVER CONTROLS
.add_controls <- function(solver) {
    ## qpOASES
    ROI_plugin_register_solver_control( solver, "printLevel", "verbose" )

    ROI_plugin_register_solver_control( solver, "hessian_type", "X" )
    ROI_plugin_register_solver_control( solver, "max_num_wsr ", "X" )
    ROI_plugin_register_solver_control( solver, "cputime ", "X" )    

    invisible( TRUE )
}

.onLoad <- function( libname, pkgname ) {
    solver <- "qpoases"
    ## Solver plugin name (based on package name)
    if( ! pkgname %in% ROI_registered_solvers() ){
        ## Register solver methods here.
        ## One can assign several signatures a single solver method
        ROI_plugin_register_solver_method(
            signatures = make_qpoases_signatures(),
            solver = solver,
            method = getFunction( "solve_OP", where = getNamespace(pkgname)) )
        ## Finally, for status code canonicalization add status codes to data base
        .add_status_codes( solver )
        .add_controls( solver )
    }
}

