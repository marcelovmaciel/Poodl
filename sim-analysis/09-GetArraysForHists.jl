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

#using StatsPlots


import Base.Iterators
const it = Base.Iterators
using StatsBase,Distributions, KernelDensity
import  PyPlot
const plt = PyPlot


simoutmeans,simoutstd = map(fn ->
                            ([ParamSweep6params★ ParamSweep6params★★ ParamSweep6params★★★ ]
                             .|> (foo -> (collect ∘ it.flatten ∘ map)(fn, foo.outputArray))), [first,last])

foo1 = map(foo -> fit(Histogram, foo, nbins=30), simoutmeans)
foo2 = map(foo -> fit(Histogram, foo, nbins=30), simoutstd)
#foo2 = map( (x -> x.density) ∘ kde, simoutmeans)


#plot(foo2[1][range(1, step = 25, stop = foo2[1] |> length)], seriestype = [:scatter,  :path])

fig = plt.figure(dpi = 200)
ax = plt.axes()
#ax.ticklabel_format(style = "plain", axis = "y")
ax.scatter( ((foo2[1].edges |> collect)[1] |> collect)[1:end-1],foo2[1].weights, label = "P*", marker = "*")
ax.plot(((foo2[1].edges |> collect)[1] |> collect)[1:end-1],foo2[1].weights)
ax.scatter( ((foo2[2].edges |> collect)[1] |> collect)[1:end-1],foo2[2].weights, marker = "^",  label = "P**")
ax.plot(((foo2[2].edges |> collect)[1] |> collect)[1:end-1],foo2[2].weights)
ax.scatter( ((foo2[3].edges |> collect)[1] |> collect)[1:end-1],foo2[3].weights, marker = "o",  label = "P***")
ax.plot(((foo2[3].edges |> collect)[1] |> collect)[1:end-1],foo2[3].weights)
ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agent's std opinion")
ax.set_title("End state")


fig = plt.figure(dpi = 200)
ax = plt.axes()
#ax.ticklabel_format(style = "plain", axis = "y")
ax.scatter( ((foo1[1].edges |> collect)[1] |> collect)[1:end-1],foo1[1].weights, label = "P*", marker = "*")
ax.plot(((foo1[1].edges |> collect)[1] |> collect)[1:end-1],foo1[1].weights)
ax.scatter( ((foo1[2].edges |> collect)[1] |> collect)[1:end-1],foo1[2].weights, marker = "^",  label = "P**")
ax.plot(((foo1[2].edges |> collect)[1] |> collect)[1:end-1],foo1[2].weights)
ax.scatter( ((foo1[3].edges |> collect)[1] |> collect)[1:end-1],foo1[3].weights, marker = "o",  label = "P***")
ax.plot(((foo1[3].edges |> collect)[1] |> collect)[1:end-1],foo1[3].weights)
ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agent's mean opinion")
ax.set_title("End state")


#down here i use Plots

p1 = histogram([simoutmeans...],
               label = [ "P*", "P**", "P***"],
               title = "End state",
               titlefontsize = 12,
               xlabel =  "Agents' mean opinion",
               ylabel = "Frequency",
               yformatter = :plain,
               nbins = 500, fill = true,
               alpha = 0.4)


p2 = histogram([simoutstd...],
               label = [ "P*", "P**", "P***"],
               title = "End state",
               xlabel =  "Agents' opinion std",
               ylabel = "Frequency",
               titlefontsize = 12,
               yformatter = :plain,
               nbins = 500, fill = true,
               alpha = 0.4)


pfinal = plot(p1,p2,dpi = 200, layout = @layout [a b])

savefig(pfinal, "img/array-hist-end.png")


function plotinitcond(param)
    p1,p2 = (histogram((collect ∘ it.flatten ∘ map)(x-> x[1], param.initcondmeasure),
                       bins = :scott, nbins = 100, normed = false, yformatter = :plain, fill = true,
                       title = "Initial condition", titlefontsize = 10,
                       ylabel = "Frequency", xlabel =  "Agents' mean opinion",
                       legend = false),
             histogram((collect ∘ it.flatten ∘ map)(x-> x[2],param.initcondmeasure) ,
                       bins = :scott, nbins = 100, normed = false, yformatter = :plain, fill = true,
                       title = "Initial condition",titlefontsize = 10,
                       ylabel = "Frequency", xlabel =  "Agents' opinion std",
                       legend = false))
    l = @layout [a b]
    pstart = plot(p1,p2, layout = l, dpi = 200)
    savefig(pstart, "img/array-hist-init.png")
end


plotinitcond(ParamSweep6params★)
