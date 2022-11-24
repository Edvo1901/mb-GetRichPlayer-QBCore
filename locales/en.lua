local Translations = {
    command = {
        name = "topmoney",
        help = "Get money of top players",
    },
    message = {
        top_without_license = "**%{name}** (%{citizenid}) | %{money} | **TOTAL MONEY:** $%{totalMoney}\n",
        top_with_license = "**%{name}** (%{citizenid}) | %{license} | %{money} | **TOTAL MONEY:** $%{totalMoney}\n",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})