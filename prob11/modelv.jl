using JuMP
using SCIP  # or any other suitable nonlinear solver
using LinearAlgebra

function min_ratio_distance(n::Int, d::Int)
    model = Model(SCIP.Optimizer)

    @variable(model, -2 <= x[1:n, 1:d] <= 2)  # n points in d-dimensional space
    @variable(model, alpha >=  0)
    # Introduce variables for min and max squared distances

    # Enforce t_min ≤ dist_ij ≤ t_max for all i < j
    @constraint(model, [i=1:n],  sum((x[i,k])^2 for k in 1:d) == 4 )
    @constraint(model, [i=1:n-1, j=i+1:n], 8 - 2 * sum(x[i,k] * x[j,k] for k in 1:d) >= 4 * alpha)

    # Objective: minimize the square root of ratio t_max / t_min
    @objective(model, Min, -alpha)

    JuMP.write_to_file(model, "model.nl")

    return
    optimize!(model)

    println("Solver status: ", termination_status(model))

    if termination_status(model) == MOI.OPTIMAL || termination_status(model) == MOI.LOCALLY_SOLVED
        obj_val = objective_value(model)
        println("Optimal value (ratio): ", obj_val)
        return obj_val
    else
        error("Solver did not converge.")
    end
end

min_ratio_distance(594, 11)
