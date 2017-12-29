<#
.synopsis Parse given string, with business rules

.description 
write a program that parses a sentence and replaces each
word with the following: first letter, number of distinct characters between first and last character, and
last letter. For example, Smooth would become S3h. Words are separated by spaces or non-alphabetic
characters and these separators should be maintained in their original form and location in the answer.


#>
cls

[string] $sentence = "098 Smooth abc-bee,caa,d_e f  g$";

function ConvertWord ([string] $word) {
    if(!$word) { return ""; }
    [string] $firstLetter = $word.Substring(0, 1);
    [string] $middleLength = "1";
    if($word.Length -gt 1) {
        [string] $middleLetters = $word.Substring(1, $word.Length -2);
        [string] $uniqueLetters = $middleLetters | % { $_.ToCharArray() } | sort -CaseSensitive -Unique;
        $uniqueLetters = $uniqueLetters.Replace(" ", "");
        $middleLength = $uniqueLetters.Length;
    }
    # [string] $wordLength = if($word.Length -eq 1) { $word.Length; } else { $word.Substring(1, $word.Length -2).Length | Get-Unique; }

    [string] $lastLetter = $word.Substring($word.Length -1, 1);
    [string] $newWord = $firstLetter + $middleLength + $lastLetter;
    return $newWord;
}

Write-Host "Original Sentence: '$sentence'"
[string[]] $convertedSentence = @();

$stringArray = $sentence -split '[^a-zA-Z0-9]' | ? {$_};
foreach($word in $stringArray) { 
    $convertedSentence += ConvertWord $word; 
}

$finalSentence = $convertedSentence -join " "
$finalSentence;
