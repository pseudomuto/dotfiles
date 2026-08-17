# Interface Design for Testability

Good interfaces make testing natural:

1. **Accept dependencies, don't create them**

In Go, this is often said as "accept interfaces, return structs".

```typescript
// Testable
function processOrder(order, paymentGateway) {}

// Hard to test
function processOrder(order) {
  const gateway = new StripeGateway();
}
```

1. **Return results, don't produce side effects**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

2. **Small surface area**
   - Fewer methods = fewer tests needed
   - Fewer params = simpler test setup
