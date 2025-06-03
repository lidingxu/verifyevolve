
using JuMP
using SCIP

function pack_circles(n::Int)
    model = Model(SCIP.Optimizer)

    @variable(model, 0 <= l <= 2) # length
    @variable(model, 0 <= w <= 2) # height
    @variable(model, 0 <= r[1:n] <= 0.5) # Radii
    @variable(model, 0 <= x[i=1:n] <= 2)
    @variable(model, 0 <= y[i=1:n] <= 2)

    @constraints(model, begin
        # Ensure circles are within the unit square
        [i=1:n], r[i] <= x[i]
        [i=1:n], x[i] <= l - r[i]
        [i=1:n], r[i] <= y[i]
        [i=1:n], y[i] <= w - r[i]
        w + l == 2  # Ensure the total width and height is 2
    end)


    # Non-overlapping constraints
    for i in 1:n-1
        for j in i+1:n
            @constraint(model, (x[i] - x[j])^2 + (y[i] - y[j])^2 ≥ (r[i] + r[j])^2)
        end
    end


    # Objective: maximize the sum of the radii
    @objective(model, Max, sum(r[i] for i in 1:n))

    print("writing: prob13n$(n).nl")
    JuMP.write_to_file(model, "prob13n$(n).nl")

    return model
end

pack_circles(21)