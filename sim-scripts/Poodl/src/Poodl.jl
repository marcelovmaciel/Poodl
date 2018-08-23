module Poodl

import LightGraphs, MetaGraphs, Distributions, DataFrames
import Parameters, ProgressMeter, JLD2, StatsBase, Random
using StatPlots

const Dist = Distributions
const DF = DataFrames
const Param = Parameters
const LG = LightGraphs
const Meter = ProgressMeter
const RD = Random

Poodl.create_agent("mutating o", 3, 1, 0.1, (2,2))

# package code goes here
include("01_basefns.jl")
include("02_runfns.jl")


end # module
