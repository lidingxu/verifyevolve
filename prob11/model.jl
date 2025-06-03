using JuMP
using SCIP  # or any other suitable nonlinear solver
using LinearAlgebra

function min_ratio_distance(n::Int, d::Int)
    model = Model(SCIP.Optimizer)

    @variable(model, -2 <= x[1:n, 1:d] <= 2)  # n points in d-dimensional space
    @variable(model, t[1:n], Bin)
    # Introduce variables for min and max squared distances

    # Enforce t_min ≤ dist_ij ≤ t_max for all i < j
    @constraint(model, [i=1:n],  sum((x[i,k])^2 for k in 1:d) == 4 * t[i])
    @constraint(model, [i=1:n-1, j=i+1:n], 4*t[i] + 4*t[j] - 2 * sum(x[i,k] * x[j,k] for k in 1:d) >= 4)

    # Objective: minimize the square root of ratio t_max / t_min
    @objective(model, Min, -sum(t[i] for i in 1:n))

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

min_ratio_distance(600, 11)
