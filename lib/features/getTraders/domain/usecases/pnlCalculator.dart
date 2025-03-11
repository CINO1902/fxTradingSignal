double calculatePNL({
  required String tradeType, // "BUY" or "SELL"
  required String currencyPair, // e.g. "EURUSD", "USDJPY", "BTCUSD", "ETHUSD"
  required double entryPrice,
  required double currentPrice,
  double lotSize = 0.1, // Standard lot (0.1 lot in Forex = 10,000 units)
}) {
  double pipValue;
  double valuePerPip;

  if (currencyPair.contains("JPY")) {
    pipValue = 0.01; // JPY pairs have 2 decimal places per pip
  } else if (currencyPair.contains("BTC") || currencyPair.contains("ETH")) {
    pipValue = 1.0; // Crypto pairs typically move in whole dollars
  } else {
    pipValue = 0.0001; // Regular Forex pairs (EURUSD, GBPUSD, etc.)
  }

  if (currencyPair.contains("BTC")) {
    valuePerPip = 1 * lotSize * 10; // 1 lot = 1 BTC, so per pip = $100
  } else if (currencyPair.contains("ETH")) {
    valuePerPip = 1 * lotSize * 1; // 1 lot = 1 ETH, so per pip = $10
  } else {
    valuePerPip = (100000 * pipValue) * lotSize; // Standard Forex pairs
  }

  // Calculate PNL
  double pnl = tradeType.toUpperCase() == "BUY"
      ? (currentPrice - entryPrice) / pipValue * valuePerPip
      : (entryPrice - currentPrice) / pipValue * valuePerPip;

  // Round to 2 decimal places
  return double.parse(pnl.toStringAsFixed(2));
}
