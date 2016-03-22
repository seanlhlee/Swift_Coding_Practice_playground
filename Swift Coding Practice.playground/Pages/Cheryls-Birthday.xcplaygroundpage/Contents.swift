//: [Previous](@previous)
/*
When is Cheryl's Birthday?
Peter Norvig, April 2015
This logic puzzle has been making the rounds:

Albert and Bernard just became friends with Cheryl, and they want to know when her birtxhday is. Cheryl gave them a list of 10 possible dates:

May 15     May 16     May 19
June 17    June 18
July 14    July 16
August 14  August 15  August 17
Cheryl then tells Albert and Bernard separately the month and the day of the birthday respectively.

Albert: I don't know when Cheryl's birthday is, but I know that Bernard does not know too.

Bernard: At first I don't know when Cheryl's birthday is, but I know now.

Albert: Then I also know when Cheryl's birthday is.

So when is Cheryl's birthday?</i>

Problem-Solving Tools
Cheryl's puzzle was designed to be solved with a pencil, the greatest problem-solving tool in the history of mathematics (although some prefer a pen, chalk, marker, or a stick for drawing in the sand). But I will show how to solve it with another tool: computer code. I choose this tool for four reasons:

It is a more direct way to find the solution. All I have to do is faithfully describe the problem with code that says: "for each of the 10 possible dates, tell Albert the month and Bernard the day and check if statements 3 through 5 are true." The intended pencil and paper solution requires not just understanding the problem, but also creatively discovering the steps of the solution—a harder task.
With tested, debugged code, you're less likely to make a mistake that leads you to a wrong answer.
You'll learn how to solve problems that are similar, but can't be solved with pencil and paper because they have millions of possibilities rather than just 10.
Solving puzzles is fun; programming is fun; solving puzzles with programs is double fun.
We will translate each of the 6 statements in the puzzle into Python code:

1. Cheryl gave them a list of 10 possible dates:
In [1]:
DATES = ['May 15',    'May 16',    'May 19',
'June 17',   'June 18',
'July 14',   'July 16',
'August 14', 'August 15', 'August 17']
We'll also define accessor functions for the month and day of a date:

In [2]:
def Month(date): return date.split()[0]

def Day(date):   return date.split()[1]
In [3]:
Month('May 15')
Out[3]:
'May'
In [4]:
Day('May 15')
Out[4]:
'15'
2. Cheryl then tells Albert and Bernard separately the month and the day of the birthday respectively.
We can define the idea of telling, and while we're at it, the idea of knowing a birthdate:

In [5]:
def tell(part, possible_dates=DATES):
"Cheryl tells a part of her birthdate to someone; return a new list of possible dates that match the part."
return [date for date in possible_dates if part in date]

def know(possible_dates):
"A person knows the birthdate if they have exactly one possible date."
return len(possible_dates) == 1
Note that we use a list of dates to represent someone's knowledge of the possible birthdates, and that someone knows the birthdate when they get down to only one possibility. For example: If Cheryl tells Albert that her birthday is in May, he would have a list of three possible birthdates:

In [6]:
tell('May')
Out[6]:
['May 15', 'May 16', 'May 19']
And if she tells Bernard that her birthday is on the 15th, he would end up with two possibilities:

In [7]:
tell('15')
Out[7]:
['May 15', 'August 15']
With two possibilities, Bernard does not know the birthdate:

In [8]:
know(tell('15'))
Out[8]:
False
Overall Strategy
When Cheryl tells Albert 'May' then he knows there are three possibilities, but we (the puzzle solvers) don't, because we don't know what Cheryl said. So what can we do? We will consider all of the possible dates, one at a time. For example, first consider 'May 15'. Cheryl tells Albert 'May' and Bernard '15', giving them the lists of possible birthdates shown above. We can then check whether statements 3 through 5 are true in this scenario. If they are, then 'May 15' is a solution to the puzzle. Repeat the process for each of the possible dates. If all goes well, there should be exactly one solution.

Here is the main function, cheryls_birthday:

In [9]:
def cheryls_birthday(possible_dates=DATES):
"Return a list of the possible dates for which statements 3 to 5 are true."
return filter(statements3to5, possible_dates)

def statements3to5(date): return statement3(date) and statement4(date) and statement5(date)

## TO DO: define statement3, statement4, statement5
(Python note: filter(predicate, items) returns a list of all items for which predicate(item) is true.)

3. Albert: I don't know when Cheryl's birthday is, but I know that Bernard does not know too.
The function statement3 takes as input a possible birthdate and returns true if Albert's statement is true for that birthdate. How do we go from Albert's English statement to a Python function? Let's paraphrase in a form that is closer to Python code:

Albert: After Cheryl told me the month of her birthdate, I didn't know her birthday. I don't know which day Cheryl told Bernard, but I know that for all of the possible dates, if Bernard is told that day, he wouldn't know the birthdate.
That I can translate directly into code:

In [10]:
def statement3(date):
"Albert: I don't know when Cheryl's birthday is, but I know that Bernard does not know too."
possible_dates = tell(Month(date))
return (not know(possible_dates)
	and all(not know(tell(Day(d)))
		for d in possible_dates))
We can try the function on a date:

In [11]:
statement3('May 15')
Out[11]:
False
In fact, we can see all the dates that satisfy statement 3:

In [12]:
filter(statement3, DATES)
Out[12]:
['July 14', 'July 16', 'August 14', 'August 15', 'August 17']
4. Bernard: At first I don't know when Cheryl's birthday is, but I know now.
Again, a paraphrase:

Bernard: At first Cheryl told me the day, and I didn't know. Then I considered just the dates for which Albert's statement 3 is true, and now I know.
In [13]:
def statement4(date):
"Bernard: At first I don't know when Cheryl's birthday is, but I know now."
at_first = tell(Day(date))
return (not know(at_first)
	and know(filter(statement3, at_first)))
Let's see which dates satisfy both statement 3 and statement 4:

In [14]:
filter(statement4, filter(statement3, DATES))
Out[14]:
['July 16', 'August 15', 'August 17']
Wait a minute—I thought that Bernard knew?! Why are there three possible dates remaining? Bernard does indeed know the birthdate, because he knows something we don't know: the day. We won't know the birthdate until after statement 5.

5. Albert: Then I also know when Cheryl's birthday is.
Albert is saying that after hearing the month and Bernard's statement 4, he now knows Cheryl's birthday:

In [15]:
def statement5(date):
"Albert: Then I also know when Cheryl's birthday is."
return know(filter(statement4, tell(Month(date))))
6. So when is Cheryl's birthday?
Let's see:

In [16]:
cheryls_birthday()
Out[16]:
['July 16']
Success! We have deduced that Cheryl's birthday is July 16. It is now True that we know Cheryl's birthday:

In [17]:
know(cheryls_birthday())
Out[17]:
True

*/












// When is Cheryl's Birthday
// adapted from Peter Norvig's code in http://nbviewer.ipython.org/url/norvig.com/ipython/Cheryl.ipynb

import Foundation

// 1. Albert and Bernard just became friends with Cheryl, and they want to know when her birthday is. Cheryl gave them a list of 10 possible dates:
//       May 15       May 16       May 19
//      June 17      June 18
//      July 14      July 16
//    August 14    August 15    August 17

// 2. Cheryl then tells Albert and Bernard seperately the month and day of the birthday respectively.
// 3. Albert  : I don't know when Cheryl's birthday is, but I know that Bernard does not know too.
// 4. Bernard : At first I don't know when Cheryl's birthday is, but I know now.
// 5. Albert  : Then I also know when Cheryls birthday is.

// So when is Cheryl's Birthday?

let dates = ["May 15",    "May 16",    "May 19",
             "June 17",   "June 18",
             "July 14",   "July 16",
             "August 14", "August 15", "August 17"]

func Month(date: String) -> String {
	return date.componentsSeparatedByString(" ")[0]
}
Month("May 15")

func Day(date: String) -> String {
	return date.componentsSeparatedByString(" ")[1]
}
Day("May 15")

func tell(part: String, possibleDates: [String]) -> [String] {
	return possibleDates.filter(){ $0.rangeOfString(part) != nil }
}
tell("May", possibleDates: dates)
tell("15", possibleDates: dates)

func know(possibleDates: [String]) -> Bool {
	return possibleDates.count == 1
}
know(tell("15", possibleDates: dates))

// Overall Strategy
// When Cheryl tells Albert "May" then he knows there are three possibilities, but we (the puzzle solvers) don't, because we don't know what Cheryl said. So what can we do? We will consider all of the possible dates, one at a time. For example, first consider "May 15". Cheryl tells Albert "May" and Bernard "15", giving them the lists of possible birthdates shown above. We can then check whether statements 3 through 5 are true in this scenario. If they are, then "May 15" is a solution to the puzzle. Repeat the process for each of the possible dates. If all goes well, there should be exactly one solution.

func not(value: Bool) -> Bool { return !value }


// Albert: After Cheryl told me the month of her birthdate, I didn't know her birthday. I don't know which day Cheryl told Bernard, but I know that for all of the possible dates, if Bernard is told that day, he wouldn't know the birthdate.
func statement3(date: String) -> Bool {
	let albertPossibleDates = tell(Month(date), possibleDates: dates)
	var result = not(know(albertPossibleDates)) // Confirm that Albert doesn't know the date
	for d in albertPossibleDates {
		result = result && not(know(tell(Day(d), possibleDates: dates)))
	}
	return result
}
statement3("May 15")
let statementThree = dates.filter(statement3)
print("Dates satisfied by Statement 3: \(statementThree)")


// Bernard: At first Cheryl told me the day, and I didn't know. Then I considered just the dates for which Albert's statement3 is true, and now I know.
func statement4(date: String) -> Bool {
	let atFirst = tell(Day(date), possibleDates: dates)
	return not(know(atFirst)) && know(atFirst.filter(statement3))
}
// The dates which satisfy both statement 3 and 4 are
let statementThreeAndFour = statementThree.filter(statement4)
print("Dates satisfied by Statement 3 & 4: \(statementThreeAndFour)")


// Albert: Then I also know when Cheryl's birthday is
func statement5(date: String) -> Bool {
	let months = tell(Month(date), possibleDates: dates)
	return know(months.filter(statement4))
}
statement5("May 15")
let statementFive = dates.filter(statement5)
print("Dates satisfied by Statement 5: \(statementFive)")

func statements3to5(date: String) -> Bool {
	return statement3(date) && statement4(date) && statement5(date)
}
//func cherylsBirthday(possibleDates: [String]) -> [String] {
//    return possibleDates.filter
//}
//: [Next](@next)
