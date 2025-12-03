# L-1 MCS 471 Mon 22 Aug 2022 : binarynum.jl
# Exploration of binary numbers.

"""
Prompts the user for the number of bits,
generates that number of random bits and
returns the string representation of the bits.
"""
function randombits()
    print("Give the number of bits in the integer part : ")
    line = readline(stdin)
    nbintr = parse(Int, line)
    intbits = [rand(0:1) for n=1:nbintr]
    strintbits = string(intbits)
    println("Bits in a random integer : $strintbits.");
    strbits = join([string(b) for b in intbits])
    println("A random integer in binary : $strbits.");
    return strbits
end

"""
Given in s are the bits of a positive integer number.
Returns the value of the the number
represented by the bits in s.
"""
function evaluate_to_integer(s::String)
    bits = [parse(Int, s[k]) for k=1:length(s)]
    result = bits[1]
    for k=2:length(bits)
        result = result*2 + bits[k]
    end
    return result
end

"""
Given in s are the bits of a positive integer fraction
Returns the value of the the number
represented by the bits in s.
"""
function evaluate_to_fraction(s::String)
    bits = [parse(Int, s[k]) for k=1:length(s)]
    result = bits[length(bits)]
    for k=length(bits)-1:-1:1
        result = result//2 + bits[k]
    end
    return result//2
end

"""
Given in s are the bits of a binary number.
Returns the rational value of the the number
represented by the bits in s.
"""
function evaluate(s::String)
    (integerpart, fractionpart) = split(s, ".")
    integervalue = evaluate_to_integer(String(integerpart))
    strintegerval = string(integervalue)
    println("The value of the integer part $integerpart : $strintegerval.");
    fractionvalue = evaluate_to_fraction(String(fractionpart))
    strfractionval = string(fractionvalue)
    println("The value of the fraction part $fractionpart : $strfractionval.");
    return integervalue + fractionvalue
end

"""
Returns the array of bits in the binary expansion
of the given integer number n.
"""
function integer_to_binary(n::Int64)
    bits = []
    nbr = n
    while nbr > 0
        rmd = rem(nbr, 2)  # remainder after division by 2
        nbr = div(nbr, 2)  # quotient after division by 2
        push!(bits, rmd)   # push remainder
    end
    result = [bits[k] for k=length(bits):-1:1] # revert order
    return result
end

"""
Returns the array of bits in the binary expansion
of the given fraction number n.
Assumed is that the expansion of n is finite,
otherwise, the loop in the function does not end.
"""
function fraction_to_binary(n::Rational)
    bits = []
    nbr = n
    while nbr > 0
        nbr = nbr * 2
        if nbr >= 1
            push!(bits, 1)
            nbr = nbr - 1
        else
            push!(bits, 0)
        end
    end
    result = [bits[k] for k=1:length(bits)]
    return result
end

"""
generates a random integer and fraction part
"""
function main()
    integerpart = randombits()
    fractionpart = randombits()
    binarynumber = join([integerpart, ".", fractionpart])
    println("A random binary number : $binarynumber.")
    value = evaluate(binarynumber)
    strval = string(value)
    println("The value of $binarynumber : $strval.")
    # convert a 5-digit integer to binary
    nbr = rand(10000:99999) # random five digit number
    strnbr = string(nbr)
    bitsnbr = integer_to_binary(nbr)
    strbits = string(bitsnbr)
    println("The bits in the binary expansion of $strnbr :")
    println("$strbits")
    strnum = join([string(bitsnbr[k]) for k=1:length(bitsnbr)])
    strval = evaluate_to_integer(strnum)
    println("The value of $strnum : $strval.")
    # convert a fraction to binary
    numval = numerator(value)
    denval = denominator(value)
    quotient = div(numval, denval)
    fraction = value - quotient
    strfrac = string(fraction)
    println("A fraction : $strfrac.")
    bitsfrac = fraction_to_binary(fraction)
    strbits = string(bitsfrac)
    println("The bits in the binary expansion of $strfrac :")
    println("$strbits")
end

main()
