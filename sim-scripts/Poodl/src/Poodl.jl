module Poodl

import LightGraphs, MetaGraphs, Distributions, DataFrames
import Parameters, ProgressMeter, JLD2,  StatsBase
using StatPlots

const Dist = Distributions
const DF = DataFrames
const Param = Parameters
const LG = LightGraphs
const Meter = ProgressMeter


# package code goes here
include("01_basefns.jl")
include("02_runfns.jl")


end # module
