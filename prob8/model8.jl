using JuMP
using SCIP  # or any other suitable nonlinear solver
using LinearAlgebra

function min_ratio_distance(n::Int, d::Int)
    model = Model(SCIP.Optimizer)

    @variable(model, 0 <= x[1:n, 1:d] <= 1, base_name="x")  # n points in d-dimensional space

    # Introduce variables for min and max squared distances
    @variable(model, t_min >= 0, base_name="t_min")
    @variable(model, t_max >= 0, base_name="t_max")
    @variable(model, r >= 0, base_name="ratio")

    # Enforce t_min ≤ dist_ij ≤ t_max for all i < j
    @constraint(model, [i=1:n-1, j=i+1:n],  sum((x[i,k] - x[j,k])^2 for k in 1:d) >= t_min)
    @constraint(model, [i=1:n-1, j=i+1:n],  sum((x[i,k] - x[j,k])^2 for k in 1:d) <= 1)
    @constraint(model, t_max == 1)

    @constraint(model, r * t_min >= 1)  # r is the square root of the ratio t_max / t_min

    # Objective: minimize the square root of ratio t_max / t_min
    @objective(model, Min, r)

    print("writing: prob8n$(n)d$(d).nl")
    JuMP.write_to_file(model, "prob8n$(n)d$(d).nl")

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

min_ratio_distance(14, 3)
min_ratio_distance(16, 2)