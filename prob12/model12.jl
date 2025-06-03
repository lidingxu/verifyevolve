using JuMP
using SCIP

function pack_circles(n::Int)
    model = Model(SCIP.Optimizer)

    @variable(model, 0 <= r[1:n] <= 0.5)              # Radii
    @variable(model, 0 <= x[i=1:n] <= 1)
    @variable(model, 0 <= y[i=1:n] <= 1)

    @constraints(model, begin
        # Ensure circles are within the unit square
        [i=1:n], r[i] <= x[i]
        [i=1:n], x[i] <= 1 - r[i]
        [i=1:n], r[i] <= y[i]
        [i=1:n], y[i] <= 1 - r[i]
    end)

    # Non-overlapping constraints
    for i in 1:n-1
        for j in i+1:n
            @constraint(model, (x[i] - x[j])^2 + (y[i] - y[j])^2 ≥ (r[i] + r[j])^2)
        end
    end


    # Objective: maximize the sum of the radii
    @objective(model, Max, sum(r[i] for i in 1:n))

    print("writing: prob12n$(n).nl")
    JuMP.write_to_file(model, "prob12n$(n).nl")

    return model
end

pack_circles(26)
pack_circles(32)