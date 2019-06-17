using Base.Filesystem

path = "../article/img/series"

foo = readdir(path)
foo2 = map( x ->  path * "/" * x, foo)

files = (Dict ∘ zip)(foo2, readdir.(foo2))

fullfilepaths = []
for (key,value) in files
    for val in value
        fullfilepath = key * "/" * val
       append!(fullfilepaths, [fullfilepath])
    end
end


for file in fullfilepaths
   rename(file, ".." * (replace(file, "★" => "*" ) |>
              x-> replace(x, "." => "") |>
              x -> x[1: end-3] * ".png"))
end




