<#
.synopsis Parse given string, with business rules

.description 
write a program that parses a sentence and replaces each word with the following: 
 - first letter
 - number of distinct characters between first and last character
 - last letter. For example, Smooth would become S3h. 

Words are separated by spaces or non-alphabetic characters and these separators should be maintained in their original form and location in the answer.

.notes
2017.12.29 - E.Haack - Initial Development
#>

Param (
	[ValidateNotNull()]
	[string] $sentence =  "Hello, this is the default sentence."
)

function ConvertWord ([string] $word) {
    if(!$word) { return ""; }

    #Buisness Rule: Get First Letter of word...
    [string] $firstLetter = $word.Substring(0, 1);

    #Buiness Rule: Get Middle word length. 
    #NOTE: It was unsaid, but if the word is only 1 character, assumed to set it to 0 as there are no middle chars...
    [string] $middleLength = "0";

    if($word.Length -gt 1) {
        [string] $middleLetters = $word.Substring(1, $word.Length -2);
        #Get remove duplicate characters from the found 'middleletters' of the word... Note: 'sort -Unique' handles removing duplicate characters
        [string] $uniqueLetters = $middleLetters | % { $_.ToCharArray() } | sort -Unique;
        #Clean up any spaces replaced... It's possible that there may be no unique characters...
        if($uniqueLetters) {
            $middleLength = $uniqueLetters.Replace(" ", "").Length;
        }
    }
    #Business Rule: Get Last Letter of the word....
    [string] $lastLetter = $word.Substring($word.Length -1, 1);

    #Return the middle value....
    return $firstLetter + $middleLength + $lastLetter;
}

function IsCharAlphaNum ([string] $charToTest) {
    #Using Regular Expressions to filter only alpha and numberic characters. Not using '\w' because it allows spaces and other unwanted characters...
    return $charToTest -match "[a-zA-Z0-9]"
}

function GetLastIndexOfWord ([string] $content, [int] $startingIndex, [int] $endingIndex) {
    [int] $currentIndex = $startingIndex;
    #Loop through each character in the content, starting at the provided index... 
    for ([int] $i = $startingIndex; $i -le $content.Length -1; $i++) {
        $currentIndex = $i;
        #Get the current char value...
        [string] $currentChar = $content[$i];
        #If the current char is not alphanum, return the last index value...
        [bool] $currentCharIsAlphaNum = IsCharAlphaNum $currentChar;
        if(!($currentCharIsAlphaNum)) {
            #Return the current index, minus 1 b/c the current char is non-alphanum
            return $currentIndex - 1;
        }
    }
    #Return the final current index...
    return $currentIndex;
}

[int] $wordStartIndex = 0; #Used as an alias for the current index in the below loop...
[int] $sentenceIndexLength = $sentence.Length - 1; #For ease of use and better describe its purpose...

#Example of using .NET in Powershell...
[System.Text.StringBuilder] $finalSentenceBuilder = [System.Text.StringBuilder]::new()

for([int] $i=0; $i -le $sentenceIndexLength; $i++){
    $wordStartIndex = $i;
    [string] $currentChar = $sentence[$wordStartIndex];

    #Check for non-alphanum char... if non-alphanum, add it to the stringbuilder, then continue...
    [bool] $currentCharIsAlphaNum = IsCharAlphaNum $currentChar;
    if(!($currentCharIsAlphaNum)) { [void] $finalSentenceBuilder.Append($currentChar); continue;}

    #We have a value char value...

    #Get last index of next non-alphan1um char...
    [int] $currentWordLastIndex = GetLastIndexOfWord $sentence $wordStartIndex $sentenceIndexLength;

    #Finally, get the word obtained by the indexes...
    [string] $wordToConvert = $sentence.Substring($wordStartIndex, ($currentWordLastIndex - $wordStartIndex) + 1);
    [string] $convertedWord = ConvertWord $wordToConvert;
    [void] $finalSentenceBuilder.Append($convertedWord);

    #Update current loop index to forward to next character index position
    $i = $currentWordLastIndex;
}

[string] $finalSentence = $finalSentenceBuilder.ToString();

#Display the orginal sentence value...
Write-Host "
Buisness Rules Output:
Original Sentence: $sentence
Converted Sentence: $finalSentence" -BackgroundColor Black -ForegroundColor Green;

<# END OF LINE. #>