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
using PyCall


locator= pyimport("mpl_toolkits.axes_grid1.inset_locator")


simoutmeans,simoutstd = map(fn ->
                            ([ParamSweep6params★ ParamSweep6params★★ ParamSweep6params★★★ ]
                             .|> (foo -> (collect ∘ it.flatten ∘ map)(fn, foo.outputArray))), [first,last])

endmean_hist = map(foo -> fit(Histogram, foo, nbins=30), simoutmeans)
endstd_hist = map(foo -> fit(Histogram, foo, nbins=30), simoutstd)
#foo2 = map( (x -> x.density) ∘ kde, simoutmeans)


initmean, initstd  = ((collect ∘ it.flatten ∘ map)(x-> x[1], ParamSweep6params★.initcondmeasure),
                      (collect ∘ it.flatten ∘ map)(x-> x[2], ParamSweep6params★.initcondmeasure))

initmean_hist, initstd_hist = (fit(Histogram, initmean, nbins=30),
                               fit(Histogram, initstd, nbins=30))
    


diffinter_init_std = filter( x-> x < 0.085, initstd)
diffinters_end_std = map(foo -> filter( x-> x < 0.085, foo), simoutstd)
inter_init_hist = fit(Histogram, diffinter_init_std, nbins = 30 ) 
inter_end_hist = map(foo -> fit(Histogram, foo, nbins=30), diffinters_end_std)



fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()
axins = locator.inset_axes(ax, width="50%", height="75%",
                   bbox_to_anchor=(.28, .3, .9, 0.8),
                   bbox_transform=ax.transAxes, loc=3)

axins.scatter(((inter_init_hist.edges |> collect)[1] |> collect)[1:end-1], inter_init_hist.weights)
axins.plot(((inter_init_hist.edges |> collect)[1] |> collect)[1:end-1], inter_init_hist.weights)

axins.tick_params(labelleft= false, left = false)

#foo = axins.spines["left"].set_visible(false)


#axins.ticklabel_format(style = "plain", axinsis = "y")
axins.scatter( ((inter_end_hist[1].edges |> collect)[1] |> collect)[1:end-1],inter_end_hist[1].weights, marker = "*")
axins.plot(((inter_end_hist[1].edges |> collect)[1] |> collect)[1:end-1],inter_end_hist[1].weights)
axins.scatter( ((inter_end_hist[2].edges |> collect)[1] |> collect)[1:end-1],inter_end_hist[2].weights, marker = "^")
axins.plot(((inter_end_hist[2].edges |> collect)[1] |> collect)[1:end-1],inter_end_hist[2].weights)
axins.scatter( ((inter_end_hist[3].edges |> collect)[1] |> collect)[1:end-1],inter_end_hist[3].weights, marker = "o")
axins.plot(((inter_end_hist[3].edges |> collect)[1] |> collect)[1:end-1],inter_end_hist[3].weights)

ax.scatter(((initstd_hist.edges |> collect)[1] |> collect)[1:end-1], initstd_hist.weights, label = "Initial condition")
ax.plot(((initstd_hist.edges |> collect)[1] |> collect)[1:end-1], initstd_hist.weights)

ax.scatter( ((endstd_hist[1].edges |> collect)[1] |> collect)[1:end-1],endstd_hist[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((endstd_hist[1].edges |> collect)[1] |> collect)[1:end-1],endstd_hist[1].weights)

ax.scatter( ((endstd_hist[2].edges |> collect)[1] |> collect)[1:end-1],endstd_hist[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((endstd_hist[2].edges |> collect)[1] |> collect)[1:end-1],endstd_hist[2].weights)

ax.scatter( ((endstd_hist[3].edges |> collect)[1] |> collect)[1:end-1],endstd_hist[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((endstd_hist[3].edges |> collect)[1] |> collect)[1:end-1],endstd_hist[3].weights)

ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agent's std opinion")
ax.set_title(" Initial vs final condition - Opinion Standard Deviation")



fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()



ax.scatter(((initmean_hist.edges |> collect)[1] |> collect)[1:end-1], initmean_hist.weights, label = "Initial condition")
ax.plot(((initmean_hist.edges |> collect)[1] |> collect)[1:end-1], initmean_hist.weights)

#ax.ticklabel_format(style = "plain", axis = "y")
ax.scatter( ((endmean_hist[1].edges |> collect)[1] |> collect)[1:end-1],endmean_hist[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((endmean_hist[1].edges |> collect)[1] |> collect)[1:end-1],endmean_hist[1].weights)
ax.scatter( ((endmean_hist[2].edges |> collect)[1] |> collect)[1:end-1],endmean_hist[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((endmean_hist[2].edges |> collect)[1] |> collect)[1:end-1],endmean_hist[2].weights)
ax.scatter( ((endmean_hist[3].edges |> collect)[1] |> collect)[1:end-1],endmean_hist[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((endmean_hist[3].edges |> collect)[1] |> collect)[1:end-1],endmean_hist[3].weights)
ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agent's mean opinion")
ax.set_title(" Initial vs final condition - Mean Opinion")






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
