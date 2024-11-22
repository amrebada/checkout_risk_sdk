enum CheckoutRiskEnvironment {
  sandbox('sandbox'),
  production('production');

  final String value;

  const CheckoutRiskEnvironment(this.value);

  @override
  String toString() => value;
}
