function map(x, a, b, c, d)
    return (x-a)/(b-a)*(d-c)+c
end

function constrain(x, a, b)
    return math.max(math.min(x, b), a)
end

function randint(min, max)
    return math.floor(math.random()*(max-min+1)) + min
end