# Load the data
using Pkg

Pkg.activate("../sim-scripts/Poodl")

using Revise
using CSV, DataFrames, JLD2


using Poodl
const pdl = Poodl

@load "data/ParamSweep6params-star1-array.jld2" ParamSweep6params★
@load "data/ParamSweep6params-star2-array.jld2" ParamSweep6params★★
@load "data/ParamSweep6params-star3-array.jld2" ParamSweep6params★★★

ParamSweep6params★ |> typeof |> fieldnames

# Plot the data

using Plots
pyplot(legend = false)
import Base.Iterators
const it = Base.Iterators

function plotoutarray(params)

    p1,p2 = (histogram((collect ∘ it.flatten ∘ map)(x-> x[1],params[1].outputArray),
                       bins = :scott, nbins = 100, normed = false, yformatter = :plain,
                       title = "Final state: Agent's mean opinion for P*",
                        ylabel = "Frequency", xlabel = "Mean opinion value for each agent"),
             histogram((collect ∘ it.flatten ∘ map)(x-> x[2],params[1].outputArray) ,
                       bins = :scott, nbins = 100, normed = false, yformatter = :plain,
                       title = "Final state: Agent's opinion std for P*",
                       ylabel = "Frequency", xlabel = "Std of opinions for each agent"))

    p3, p4 = (histogram((collect ∘ it.flatten ∘ map)(x-> x[1],params[2].outputArray),
                        bins = :scott, nbins = 100, normed = false, yformatter = :plain,
                        title = "Final state: Agent's mean opinion for P**",
                         ylabel = "Frequency", xlabel = "Mean opinion value for each agent"),
              histogram((collect ∘ it.flatten ∘ map)(x-> x[2],params[2].outputArray),
                        bins = :scott, nbins = 100, normed = false, yformatter = :plain,
                        title = "Final state: Agent's opinion std for P**",
                        ylabel = "Frequency", xlabel = "Std of opinions for each agent"))

    p5,p6 = (histogram((collect ∘ it.flatten ∘ map)(x-> x[1],params[3].outputArray),
                       bins = :scott, nbins = 100, normed = false, yformatter = :plain,
                       title = "Final state: Agent's mean opinion for P***",
                        ylabel = "Frequency", xlabel = "Mean opinion value for each agent"),
             histogram((collect ∘ it.flatten ∘ map)(x-> x[2], params[3].outputArray),
                       bins = :scott, nbins = 100,normed = false, yformatter = :plain,
                       title = "Final state: Agent's opinion std for P***",
                       ylabel = "Frequency", xlabel = "Std of opinions for each agent"))

    l2 = @layout [a b ; c d; e f ]
    plot(p1,p2,p3,
         p4,p5,p6,
         layout = l2)
end

plotoutarray([ParamSweep6params★,
              ParamSweep6params★★,
              ParamSweep6params★★★])

function plotinitcond(param)
    p1,p2 = (histogram((collect ∘ it.flatten ∘ map)(x-> x[1], param.initcondmeasure),
                       bins = :scott, nbins = 100, normed = false, yformatter = :plain,
                       title = "Initial condition: Agent's mean opinion",
                       ylabel = "Frequency", xlabel = "Mean opinion value for each agent"),
             histogram((collect ∘ it.flatten ∘ map)(x-> x[2],param.initcondmeasure) ,
                       bins = :scott, nbins = 100, normed = false, yformatter = :plain,
                       title = "Initial condition: Agent's opinion std",
                       ylabel = "Frequency", xlabel = "Std of opinions for each agent"))
    l = @layout [a b]
    plot(p1,p2, layout = l, dpi = 200)
end

plotinitcond(ParamSweep6params★)
