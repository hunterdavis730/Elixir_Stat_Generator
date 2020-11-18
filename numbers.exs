defmodule Numbers do

    def invalidNumbers(), do: {:error, :no_numbers_to_evaluate}

    def stats(input) when length(input) > 0 do 
        getListStats(input)
    end

    def stats(input) when is_number(input) do 
        getNumberStats(input)
    end

    def stats(input) do
        if String.valid?(input) do
            getStringStats(input)
        else
            {:error, :no_expression_to_evaluate}
        end
    end

    defp getStringStats(string), do: [{:value, string}, {:isPalindrome, isPalindrome(string)}, {:isNumber, false}]

    defp getNumberStats(number), do: [{:value, number}, {:isPalindrome, isPalindrome(number)}, {:isNumber, true}, {:fibonacci_value, fibonacci(number)}, {:factorial, factorial(number)}]

    defp getListStats(input) do 
        numbers = Enum.filter(input, &(is_number(&1)))
        strings = Enum.filter(input, &(!is_number(&1)))

        returnStats(numbers, strings)
    end

    defp returnStats(numbers, strings) when length(strings) == 0, do: [{:number_stats, listNumberStats(numbers)}]

    defp returnStats(numbers, strings) when length(numbers) == 0, do: [{:string_stats, listStringStats(strings)}]

    defp returnStats(numbers, strings), do: [{:number_stats, listNumberStats(numbers)}, listStringStats(strings)]

    defp listNumberStats(numbers) do 
        getListNumberStats = getListNumberStats(numbers)
        numberStats = Enum.map(numbers, &(getNumberStats(&1)))

        [getListNumberStats, {:individual_number_stats, numberStats}]
    end

    defp getListNumberStats(numbers) do 
        [{:max, findMax(numbers)}, {:min, findMin(numbers)}, {:mean, mean(numbers)}, {:median, median(numbers)}, {:sum, sum(numbers)}, {:standard_deviation, standardDeviation(numbers)}]
    end 

    defp getNumberStats(number) do 
        [{:value, number}, {:isPalindrome, isPalindrome(number)}, {:isNumber, true}]
    end

    defp listStringStats(strings) do
        stringStats = Enum.map(strings, &(getStringStats(&1)))
        {:string_stats, stringStats}
    end

    defp getStringStats(string) do
        [{:value, string}, {:isPalindrome, isPalindrome(string)}, {:isNumber, is_number(string)}]
    end

    def findMax([head | tail]) do 
        doMax(head, tail)
    end

    defp doMax(current_max, []), do: current_max

    defp doMax(current_max, [head | tail]) when is_number(current_max) and is_number(head) == false, do: doMax(current_max, tail)

    defp doMax(current_max, [ head | tail ])when current_max >= head do
        doMax(current_max, tail)
    end

    defp doMax(current_max, [ head | tail  ])when current_max < head do 
        doMax(head, tail)
    end

    defp doMax(_, [head | tail ]) when is_number(hd tail), do: doMax(head, tail)

    defp doMax(_, [head | tail]) when length(tl tail) > 0, do: doMax(head, tl tail)

    defp doMax(_, [head | _]), do: doMax(head, [])

    def findMin([head | tail]) do 
        doMin(head, tail)
    end

    defp doMin(current_min, []), do: current_min

    defp doMin(current_min, [ head | tail ]) when is_number(current_min) == false, do: doMin(head, tail)

    defp doMin(current_min, [ head | tail ]) when is_number(current_min) and is_number(head) == false, do: doMin(current_min, tail)

    defp doMin(current_min, [ head | tail ]) when current_min <= head do 
        doMin(current_min, tail)
    end

    defp doMin(current_min, [ head | tail ]) when current_min > head do 
        doMin(head, tail)
    end

    defp doMin(_, [head | tail]) when is_number(hd tail), do: doMin(head, tail)

    defp doMin(_, [head | tail]) when length(tl tail) > 0, do: doMin(head, tl tail)

    defp doMin(_, [head | _]), do: doMin(head, [])

    def mean(numbers) when length(numbers) > 0 do 
        validNumbers = Enum.filter(numbers, &(is_number(&1)))
        if length(validNumbers) > 0 do
            getMean(validNumbers)
        else 
            invalidNumbers()
        end
    end

    def mean(_), do: invalidNumbers()

    defp getMean(numbers), do: addArrayTotal(numbers) / length(numbers)

    defp addArrayTotal([head | tail]) when length(tail) == 0, do: head

    defp addArrayTotal([head | tail]) when is_number(hd tail) do
        total = head + hd tail
        addArrayTotal([ total | tl tail])
    end

    defp addArrayTotal([head | tail]) do
        addArrayTotal([head | tl tail])
    end

    def sum(numbers) when length(numbers) > 0 do 
        validNumbers = Enum.filter(numbers, &(is_number(&1)))
        if length(validNumbers) > 0 do
            addArrayTotal(validNumbers)
        else 
            invalidNumbers()
        end
    end

    def sum(_), do: invalidNumbers()

    def median(numbers) when length(numbers) > 0  do 
        validNumbers = Enum.filter(numbers, &(is_number(&1)))
        if length(validNumbers) > 0 do
            getMedian(Enum.sort(validNumbers))
        else 
            invalidNumbers()
        end
    end

    def median(_), do: invalidNumbers()

    defp getMedian(numbers) when rem(length(numbers), 2) == 0 do
        num1 = Enum.at(numbers, trunc(length(numbers) / 2 - 1))
        num2 = Enum.at(numbers, trunc(length(numbers) / 2))
        getMean([ num1, num2])
    end

    defp getMedian(numbers) do 
        Enum.at(numbers, round(length(numbers) / 2))
    end

    def standardDeviation(numbers) when length(numbers) > 0 do 
        validNumbers = Enum.filter(numbers, &(is_number(&1)))
        if length(validNumbers) > 0 do
            getStandardDeviation(validNumbers)
        else
            invalidNumbers()
        end
    end

    def standardDeviation(number) when is_number(number), do: 0

    def standardDeviation(_), do: invalidNumbers()

    defp getStandardDeviation(numbers) when length(numbers) > 0 do
        mean = getMean(numbers)
        sqauredValues = Enum.map(numbers, &(:math.pow(&1 - mean, 2)))
        :math.sqrt(getMean(sqauredValues))
    end

    def factorial(0), do: 1

    def factorial(1), do: 1

    def factorial(number) when is_number(number) do 
        getFactorial(number, number - 1)
    end

    def factorial(_), do: invalidNumbers()

    defp getFactorial(number, multiplier) when multiplier > 1 do 
        newNumber = number * multiplier
        getFactorial(newNumber, multiplier - 1)
    end

    defp getFactorial(number, 1), do: number

    defp allFibonacci(1), do: [0]

    defp allFibonacci(2), do: [1 | allFibonacci(1)]

    defp allFibonacci(number) when  is_number(number) and number > 2 do
        [x, y |_] = all = allFibonacci(number - 1)
        [x + y | all]
    end

    def fibonacci(number) when is_integer(number) do 
        getFibonacci(number)
    end

    def fibonacci(_), do: invalidNumbers()

    defp getFibonacci(1), do: 0

    defp getFibonacci(2), do: 1

    defp getFibonacci(number), do: getFibonacci(number - 1) + getFibonacci(number - 2)

    def isPalindrome(p) when is_integer(p) do 
        if p > 0 do
            Integer.digits(p) == Enum.reverse(Integer.digits(p))
        else 
            false
        end
    end

    def isPalindrome(p) do 
        if String.valid?(p) do
            String.split(p, " ") == Enum.reverse(String.split(p, " "))
        else
            false
        end
    end

end

Numbers.stats([1, 2, 15, 23, 12, 14, 7, 10, "yooy"]) |>
IO.inspect