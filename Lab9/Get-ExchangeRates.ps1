<#
.SYNOPSIS
    The scrypt gives the exchange rates for the last 5 days for the currency code entered by the user.
.DESCRIPTION
    Fistly, the script asks the user to enter the currency code.
    Then it sends a request to the API of the National Bank of Poland. 
    Lastly, it writes out the exchange rates for the last 5 days for the given currency.
    There also is a blck for error handling, which writes out the error response message.
.PARAMETER currency
    currency contains the currency code entered by the user.
.EXAMPLE
    ./Get-ExchangeRates.ps1
    Please enter the currency code: : eur
    Exchange rate for EUR on 2026-05-07: 4.2744PLN

    Exchange rate for EUR on 2026-05-08: 4.2683PLN.
    The difference between the current and previous day is: -0.0061PLN.

    Exchange rate for EUR on 2026-05-11: 4.2715PLN.
    The difference between the current and previous day is: 0.0032PLN.

    Exchange rate for EUR on 2026-05-12: 4.2799PLN.
    The difference between the current and previous day is: 0.0084PLN.

    Exchange rate for EUR on 2026-05-13: 4.2905PLN.
    The difference between the current and previous day is: 0.0106PLN.
#>
#Getting the currency code from the user
$currency = Read-Host "Please enter the currency code: "

try {
    #Getting response from API
    $response = Invoke-RestMethod "http://api.nbp.pl/api/exchangerates/rates/c/${currency}/last/5/"
    #Writing out 5 days rates
    for ($i = 0; $i -lt $response.rates.Count; $i++) {
        #On day 1 there is no difference with the previous day
        if ($i -eq 0) {
            Write-Host "Exchange rate for $($response.code) on $($response.rates[$i].effectiveDate): $($response.rates[$i].ask)PLN"
            Write-Host ""
        }
        #Beginning with day 2, script writes out the difference between the current and previous day
        else {
            Write-Host "Exchange rate for $($response.code) on $($response.rates[$i].effectiveDate): $($response.rates[$i].ask)PLN."
            Write-Host "The difference between the current and previous day is: $(($response.rates[$i].ask - $response.rates[$i-1].ask))PLN."
            Write-Host ""
        }
    }
}
#Error handling (for example invalid currency code or absence of information about the currency code)
catch {
    Write-Host "An error occurred: $_"
}