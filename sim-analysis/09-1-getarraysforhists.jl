# Load the data
using Pkg

Pkg.activate("../sim-scripts/Poodl")

using Revise
using CSV, DataFrames, JLD2


using Poodl
const pdl = Poodl

import Base.Iterators
const it = Base.Iterators
using StatsBase,Distributions, KernelDensity
import  PyPlot
const plt = PyPlot
using PyCall

locator= pyimport("mpl_toolkits.axes_grid1.inset_locator")


# generation of the initial condition

problem = Dict("num_vars" => 5,
            "names" => ["n_issues", "p", "σ", "ρ", "p_intran"],
            "bounds" => [[2, 10],
                         [0.1, 0.99],
                         [0.01, 0.5],
                         [0.0, 0.1],
                         [0.0, 0.3]])

paramvalues5k_6params = pdl.boundsdict_toparamsdf(problem) ;

poodlvect★ = pdl.poodlparamsvec2(paramvalues5k_6params,
                               time = 1_000_000,
                               p★calculator = pdl.calculatep★);

#initcondmeasure = pdl.initconds(poodlvect★)

initopinions = pdl.initopinions(poodlvect★);

lessthan01indx = []

for (index,value) in enumerate(poodlvect★)
    if value.σ <= 0.1
        push!(lessthan01indx, index)
    end
end


#Preparation of the data


#ParamSweep6params★ |> typeof |> fieldnames

#ParamSweep6params★.initcondmeasure[1]


#ParamSweep6params★.outputArray |> foo -> map(x->length.(x), foo ) |> it.flatten |> Set


(n2init,
 n6init,
 n10init) = map(foo ->copy(filter(x -> x[1] |> length == foo,
                                 initopinions)),
                (2,6,10));

(n2init_smallσ,
 n6init_smallσ,
 n10init_smallσ) = map(foo ->copy(filter(x -> x[1] |> length == foo,
                                 initopinions[lessthan01indx])),
                (2,6,10));


@load "data/ParamSweep6params-star1-array-opinions.jld2" ParamSweep6params★

(n2★,
 n6★,
 n10★)  = map(foo -> copy(filter(x -> x[1] |> length == foo,
                                ParamSweep6params★.outputArray)),
              (2,6,10));


(n2★_smallσ,
 n6★_smallσ,
 n10★_smallσ)  = map(foo -> copy(filter(x -> x[1] |> length == foo,
                                ParamSweep6params★.outputArray[lessthan01indx])),
              (2,6,10));


ParamSweep6params★ = nothing

@load "data/ParamSweep6params-star2-array-opinions.jld2" ParamSweep6params★★

(n2★★,
n6★★,
n10★★) =  map(foo -> copy(filter(x -> x[1] |> length == foo,
                                ParamSweep6params★★.outputArray)),
              (2,6,10));


(n2★★_smallσ,
n6★★_smallσ,
n10★★_smallσ) =  map(foo -> copy(filter(x -> x[1] |> length == foo,
                                ParamSweep6params★★.outputArray[lessthan01indx])),
              (2,6,10));


ParamSweep6params★★ = nothing

@load "data/ParamSweep6params-star3-array-opinions.jld2" ParamSweep6params★★★

(n2★★★,
 n6★★★,
 n10★★★) =  map(foo -> copy(filter(x -> x[1] |> length == foo,
                                ParamSweep6params★★★.outputArray)),
              (2,6,10));


(n2★★★_smallσ,
 n6★★★_smallσ,
 n10★★★_smallσ) =  map(foo -> copy(filter(x -> x[1] |> length == foo,
                                ParamSweep6params★★★.outputArray[lessthan01indx])),
              (2,6,10));



ParamSweep6params★★★ = nothing


n2hists = map(((foo ->fit(Histogram, foo, nbins = 120)) ∘  collect  ∘ it.flatten ∘ it.flatten),
              [n2★, n2★★, n2★★★, n2init]);


n6hists =  map(((foo ->fit(Histogram, foo, nbins = 120)) ∘  collect  ∘ it.flatten ∘ it.flatten),
              [n6★, n6★★, n6★★★, n6init]);

n10hists =  map(((foo ->fit(Histogram, foo, nbins = 120)) ∘  collect  ∘ it.flatten ∘ it.flatten),
              [n10★, n10★★, n10★★★, n10init])


n2hists_smallσ = map(((foo ->fit(Histogram, foo, nbins = 120)) ∘  collect  ∘ it.flatten ∘ it.flatten),
              [n2★_smallσ, n2★★_smallσ, n2★★★_smallσ, n2init_smallσ]);


n6hists_smallσ =  map(((foo ->fit(Histogram, foo, nbins = 120)) ∘  collect  ∘ it.flatten ∘ it.flatten),
              [n6★_smallσ, n6★★_smallσ, n6★★★_smallσ, n6init_smallσ]);

n10hists_smallσ =  map(((foo ->fit(Histogram, foo, nbins = 120)) ∘  collect  ∘ it.flatten ∘ it.flatten),
              [n10★_smallσ, n10★★_smallσ, n10★★★_smallσ, n10init_smallσ])





#Plotting and so on
fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()



ax.scatter( ((n2hists[4].edges |> collect)[1] |> collect)[1:end-1],n2hists[4].weights, label = "Initial condition", marker = "*")
ax.plot(((n2hists[4].edges |> collect)[1] |> collect)[1:end-1],n2hists[4].weights)


ax.scatter( ((n2hists[1].edges |> collect)[1] |> collect)[1:end-1],n2hists[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((n2hists[1].edges |> collect)[1] |> collect)[1:end-1],n2hists[1].weights)

ax.scatter( ((n2hists[2].edges |> collect)[1] |> collect)[1:end-1],n2hists[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((n2hists[2].edges |> collect)[1] |> collect)[1:end-1],n2hists[2].weights)

ax.scatter( ((n2hists[3].edges |> collect)[1] |> collect)[1:end-1],n2hists[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((n2hists[3].edges |> collect)[1] |> collect)[1:end-1],n2hists[3].weights)

ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agents' opinions")
ax.set_title(" Initial x Final condition; n = 2")



fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()



ax.scatter( ((n6hists[4].edges |> collect)[1] |> collect)[1:end-1],n6hists[4].weights, label = "Initial condition", marker = "*")
ax.plot(((n6hists[4].edges |> collect)[1] |> collect)[1:end-1],n6hists[4].weights)


ax.scatter( ((n6hists[1].edges |> collect)[1] |> collect)[1:end-1],n6hists[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((n6hists[1].edges |> collect)[1] |> collect)[1:end-1],n6hists[1].weights)

ax.scatter( ((n6hists[2].edges |> collect)[1] |> collect)[1:end-1],n6hists[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((n6hists[2].edges |> collect)[1] |> collect)[1:end-1],n6hists[2].weights)

ax.scatter( ((n6hists[3].edges |> collect)[1] |> collect)[1:end-1],n6hists[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((n6hists[3].edges |> collect)[1] |> collect)[1:end-1],n6hists[3].weights)

ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agents' opinions")
ax.set_title("Initial x Final condition; n = 6")




fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()


ax.scatter( ((n10hists[4].edges |> collect)[1] |> collect)[1:end-1],n10hists[4].weights, label = "Initial condition", marker = "*")
ax.plot(((n10hists[4].edges |> collect)[1] |> collect)[1:end-1],n10hists[4].weights)


ax.scatter( ((n10hists[1].edges |> collect)[1] |> collect)[1:end-1],n10hists[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((n10hists[1].edges |> collect)[1] |> collect)[1:end-1],n10hists[1].weights)

ax.scatter( ((n10hists[2].edges |> collect)[1] |> collect)[1:end-1],n10hists[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((n10hists[2].edges |> collect)[1] |> collect)[1:end-1],n10hists[2].weights)

ax.scatter( ((n10hists[3].edges |> collect)[1] |> collect)[1:end-1],n10hists[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((n10hists[3].edges |> collect)[1] |> collect)[1:end-1],n10hists[3].weights)

ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agents' opinions")
ax.set_title("Initial x Final condition; n = 10")





using LaTeXStrings

#Plotting and so on
fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()



ax.scatter( ((n2hists_smallσ[4].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[4].weights, label = "Initial condition", marker = "*")
ax.plot(((n2hists_smallσ[4].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[4].weights)


ax.scatter( ((n2hists_smallσ[1].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((n2hists_smallσ[1].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[1].weights)

ax.scatter( ((n2hists_smallσ[2].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((n2hists_smallσ[2].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[2].weights)

ax.scatter( ((n2hists_smallσ[3].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((n2hists_smallσ[3].edges |> collect)[1] |> collect)[1:end-1],n2hists_smallσ[3].weights)

ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agents' opinions")
ax.set_title(L" Initial x Final condition; n = 2; $\sigma \leq 0.1$")



fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()



ax.scatter( ((n6hists_smallσ[4].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[4].weights, label = "Initial condition", marker = "*")
ax.plot(((n6hists_smallσ[4].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[4].weights)


ax.scatter( ((n6hists_smallσ[1].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((n6hists_smallσ[1].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[1].weights)

ax.scatter( ((n6hists_smallσ[2].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((n6hists_smallσ[2].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[2].weights)

ax.scatter( ((n6hists_smallσ[3].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((n6hists_smallσ[3].edges |> collect)[1] |> collect)[1:end-1],n6hists_smallσ[3].weights)

ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agents' opinions")
ax.set_title(L"Initial x Final condition; n = 6; $\sigma \leq 0.1$")



fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()


ax.scatter( ((n10hists_smallσ[4].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[4].weights, label = "Initial condition", marker = "*")
ax.plot(((n10hists_smallσ[4].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[4].weights)


ax.scatter( ((n10hists_smallσ[1].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[1].weights, label = "P*'s final state", marker = "*")
ax.plot(((n10hists_smallσ[1].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[1].weights)

ax.scatter( ((n10hists_smallσ[2].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[2].weights, marker = "^",  label = "P**'s final state")
ax.plot(((n10hists_smallσ[2].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[2].weights)

ax.scatter( ((n10hists_smallσ[3].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[3].weights, marker = "o",  label = "P***'s final state")
ax.plot(((n10hists_smallσ[3].edges |> collect)[1] |> collect)[1:end-1],n10hists_smallσ[3].weights)

ax.legend()
ax.set_ylabel("Frequency")
ax.set_xlabel("Agents' opinions")
ax.set_title(L"Initial x Final condition; n = 10; $\sigma \leq 0.1$")



#=
simoutoiks2 = reduce(vcat, [n2★, n2★★, n2★★★ ]) |> it.flatten |> it.flatten |> collect
simoutoiks6 = reduce(vcat, [n6★, n6★★, n6★★★ ]) |> it.flatten |> it.flatten |> collect
simoutoiks10 = reduce(vcat, [n10★, n10★★, n10★★★ ]) |> it.flatten |> it.flatten|> collect

simoutoiks2_hist = fit(Histogram, simoutoiks2, nbins = 120)
simoutoiks6_hist = fit(Histogram, simoutoiks6, nbins = 120)
simoutoiks10_hist = fit(Histogram, simoutoiks10, nbins = 120)




fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()



#ax.ticklabel_format(style = "plain", axis = "y")
ax.scatter( ((simoutoiks2_hist.edges |> collect)[1] |> collect)[1:end-1],
            simoutoiks2_hist.weights, marker = "*", s=10)
ax.plot(((simoutoiks2_hist.edges |> collect)[1] |> collect)[1:end-1],simoutoiks2_hist.weights)


ax.set_ylabel("Frequency")
ax.set_xlabel("Agent's opinions")
ax.set_title("Final condition; n=2")




fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()

ax.scatter( ((simoutoiks6_hist.edges |> collect)[1] |> collect)[1:end-1],simoutoiks6_hist.weights,
            marker = "^", s=10)
ax.plot(((simoutoiks6_hist.edges |> collect)[1] |> collect)[1:end-1],simoutoiks6_hist.weights)



ax.set_ylabel("Frequency")
ax.set_xlabel("Agent's opinions")
ax.set_title("Final condition; n=6")


fig = plt.figure(dpi = 200, figsize = (12,12))
ax = plt.axes()


ax.scatter( ((simoutoiks10_hist.edges |> collect)[1] |> collect)[1:end-1],simoutoiks10_hist.weights,
            marker = "o",  s=10)
ax.plot(((simoutoiks10_hist.edges |> collect)[1] |> collect)[1:end-1],simoutoiks10_hist.weights)
#plt.axhline(y=0, linestyle = "dashed", color = "black")
#ax.legend()

ax.set_ylabel("Frequency")
ax.set_xlabel("Agent's opinions")
ax.set_title("Final condition; n=10")
=#
