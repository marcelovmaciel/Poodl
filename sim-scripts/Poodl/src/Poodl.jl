module Poodl

import LightGraphs, MetaGraphs, Distributions, DataFrames
import Parameters, ProgressMeter, JLD2, Random
using StatPlots
import Statistics

const Dist = Distributions
const DF = DataFrames
const Param = Parameters
const LG = LightGraphs
const Meter = ProgressMeter
const RD = Random
const Stats = Statistics




# package code goes here
include("01_basefns.jl")
include("02_runfns.jl")

end # module
